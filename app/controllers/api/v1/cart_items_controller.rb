class Api::V1::CartItemsController < ApplicationController
  before_action :authorize_request
  before_action :set_cart, only: [:index, :update, :add_item, :remove_or_move_to_wishlist]

  def index
    @cart_items = @cart.cart_items.includes(:product_item, :product_item_variant)
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
      render json: { cart_item: @cart_item }, status: :ok and return
    else
      render json: @cart_item.errors, status: :unprocessable_entity and return
    end
  end

  def add_item
    product_item = ProductItem.find(params[:product_item_id])
    cart_item = @cart.cart_items.find_by(product_item: product_item)
  
    if cart_item.present?
      render json: { message: 'Item is already in the cart' }, status: :unprocessable_entity
    else
      cart_item = @cart.cart_items.build(product_item: product_item)
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

 
  def size_list
    @product_item = ProductItem.find_by(id: params[:id])

    if @product_item
      variants = @product_item.product_item_variants.select(:id, :size)
      render json: variants.as_json(only: [:id, :size]), status: :ok
    else
      render json: { error: 'Product Item not found' }, status: :not_found
    end
  end
  

  private

  def set_cart
    @cart = Cart.find_or_create_by(user_id: @current_user)
  end

  def cart_item_update_params
    params.require(:cart_item).permit(:quantity, :product_item_variant_id)
  end  
end