class Api::V1::CartItemsController < ApplicationController
  before_action :authorize_request
  before_action :set_cart, only: [:index, :update, :add_item, :remove_or_move_to_wishlist]

  def index
    @cart_items = @cart.cart_items.includes(:product_item, :product_item_variant).order(:created_at)
    render json: {
      data: ActiveModelSerializers::SerializableResource.new(
        @cart_items,
        each_serializer: CartItemSerializer,
        selected_variants: ->(cart_item) { [cart_item.product_item_variant] }
      )
    }
  end

  def update
    @cart_item = @cart.cart_items.find(params[:id])

    if @cart_item.update(cart_item_update_params)
      update_total_price(@cart_item)
      @cart_item.save
      render json: {
        message: 'Cart item updated',
        cart_item: CartItemSerializer.new(@cart_item).as_json
      }, status: :ok
    else
      render json: @cart_item.errors, status: :unprocessable_entity
    end
  end

  def add_item
    product_item = ProductItem.find(params[:product_item_id])

    if params[:product_item_variant_id].blank? || params[:product_item_variant_id].to_i == 0
      return render json: { message: 'Please select a valid size.' }, status: :ok
    end

    cart_item = @cart.cart_items.find_by(product_item: product_item)
  
    if cart_item.present?
      render json: { message: 'Item is already in the cart' }, status: :unprocessable_entity
    else
      cart_item = @cart.cart_items.build(product_item: product_item, product_item_variant_id: params[:product_item_variant_id], quantity: 1)
      update_total_price(cart_item)

      if cart_item.save
        render json: { message: 'Item added to cart' }
      else
        render json: cart_item.errors, status: :unprocessable_entity
      end
    end
  end
  

  def remove_or_move_to_wishlist
    cart_item = @cart.cart_items.find_by(product_item_id: params[:product_item_id])
  
    if cart_item
      case params[:action_type]
      when 'remove'
        cart_item.destroy
        render json: { message: 'Item removed' }
      when 'wishlist'
        wishlist = Wishlist.find_or_create_by(user: @cart.user)
        wishlist.wishlist_items.find_or_create_by(product_item: cart_item.product_item)
        cart_item.destroy
        render json: { message: 'Item moved to wishlist' }
      else
        render json: { error: 'Invalid action type' }, status: :bad_request
      end
    else
      render json: { error: 'Item not found in cart' }, status: :not_found
    end
  end  

  private

  def set_cart
    @cart = Cart.find_or_create_by(user_id: @current_user)
  end

  def cart_item_update_params
    params.require(:cart_item).permit(:quantity, :product_item_variant_id)
  end  

  def update_total_price(cart_item)
    item_price = cart_item.product_item_variant&.price
    cart_item.total_price = item_price * cart_item.quantity
  end
end