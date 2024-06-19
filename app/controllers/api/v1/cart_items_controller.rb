class Api::V1::CartItemsController < ApplicationController
  before_action :authorize_request
  before_action :set_cart, only: [:index, :update, :add_item, :remove_or_move_to_wishlist]

  def index
    @cart_items = @cart.cart_items.includes(:product_item)
    render json: @cart_items
  end

  def update
    @cart_item = @cart.cart_items.find(params[:id])
    if @cart_item.update(cart_item_params)
      render json: @cart_item
    else
      render json: @cart_item.errors, status: :unprocessable_entity
    end
  end

  def add_item
    product_item = ProductItem.find(params[:product_item_id])
    cart_item = @cart.cart_items.find_or_initialize_by(product_item: product_item)
    cart_item.quantity = params[:quantity].to_i
    cart_item.save
    render json: @cart, include: { cart_items: { include: :product_item } }
  end

  def remove_or_move_to_wishlist
    cart_item = @cart.cart_items.find_by(product_item_id: params[:product_item_id])
    if cart_item
      if params[:action_type] == 'remove'
        cart_item.destroy
        render json: @cart, include: { cart_items: { include: :product_item } }
      elsif params[:action_type] == 'wishlist'
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

  def cart_item_params
    params.require(:cart_item).permit(:quantity)
  end
end