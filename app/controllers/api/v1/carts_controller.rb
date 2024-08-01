class Api::V1::CartsController < ApplicationController
  before_action :authorize_request
  before_action :set_cart, only: [:show]

  def show
    @cart_items = @cart.cart_items.includes(:product_item)
    render json: { data: ActiveModelSerializers::SerializableResource.new(@cart_items, each_serializer: CartItemSerializer) }
  end

  private

  def set_cart
    @cart = Cart.find_or_create_by(user: @current_user)
  end
end
