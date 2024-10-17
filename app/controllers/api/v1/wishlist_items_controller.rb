class Api::V1::WishlistItemsController < ApplicationController
  before_action :authorize_request
  before_action :set_wishlist, only: [:add_to_cart, :create]

  def create
    @wishlist = Wishlist.find_by(user: @current_user)
    @product_item = ProductItem.find(params[:product_item_id])
    @wishlist_item = @wishlist.wishlist_items.build(product_item: @product_item)

    if @wishlist_item.save
      render json: @wishlist_item, status: :created
    else
      render json: @wishlist_item.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @wishlist_item = WishlistItem.find_by(id: params[:id])
  
    if @wishlist_item.destroy
      render json: { message: 'Removed Item form Wishlist' }, status: :ok
    else
      render json: { message: 'Wishlist item not found' }, status: :not_found
    end
  end

  def add_to_cart
    wishlist_item = @wishlist.wishlist_items.find_by(product_item_id: params[:product_item_id])
  
    if wishlist_item
      cart = Cart.find_or_create_by(user: @wishlist.user)
      product_item_variant_id = params[:product_item_variant_id] || wishlist_item.product_item_variant_id
  
      product_item_variant = ProductItemVariant.find_by(id: product_item_variant_id)
  
      if product_item_variant.nil? || !product_item_variant.in_stock
        return render json: { message: 'Out of stock.' }, status: :unprocessable_entity
      end
  
      cart_item = cart.cart_items.find_or_initialize_by(
        product_item_id: wishlist_item.product_item_id,
        product_item_variant_id: product_item_variant_id
      )
  
      cart_item.quantity = cart_item.new_record? ? 1 : cart_item.quantity + 1
      update_total_price(cart_item)
  
      if cart_item.save
        wishlist_item.destroy
        render json: { message: 'Item added to cart' }, status: :ok
      else
        render json: cart_item.errors, status: :unprocessable_entity
      end
    else
      render json: { error: 'Item not found in wishlist' }, status: :not_found
    end
  end
  
  private

  def set_wishlist
    @wishlist = Wishlist.find_by(user: @current_user)
  end

  def update_total_price(cart_item)
    item_price = cart_item.product_item_variant&.discounted_price || cart_item.product_item.discounted_price
    cart_item.total_price = item_price * cart_item.quantity
  end
end