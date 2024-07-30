class Api::V1::WishlistItemsController < ApplicationController
  before_action :authorize_request
  before_action :set_wishlist, only: [:add_to_cart, :create]

  def create
    @wishlist = Wishlist.find_by(user: @current_user)
    @product_item_variant = ProductItemVariant.find(params[:product_item_variant_id])
    @wishlist_item = @wishlist.wishlist_items.build(product_item_variant: @product_item_variant)

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
      render json: { error: 'Wishlist item not found' }, status: :not_found
    end
  end

  def add_to_cart
    wishlist_item = @wishlist.wishlist_items.find_by(product_item_variant_id: params[:product_item_variant_id])
    if wishlist_item
      cart = Cart.find_or_create_by(user: @wishlist.user)
      cart_item = cart.cart_items.find_or_initialize_by(product_item_variant: wishlist_item.product_item_variant)
      cart_item.quantity = cart_item.new_record? ? 1 : cart_item.quantity + 1
      if cart_item.save
        wishlist_item.destroy
        render json: { message: 'Item added in cart' }, status: :ok
        # render json: cart, include: { cart_items: { include: { product_item_variant: { include: :product_item } } } }
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
end