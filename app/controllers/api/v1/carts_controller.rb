class Api::V1::CartsController < ApplicationController
  before_action :authorize_request
  before_action :set_cart, only: [:show]

  def show
    render json: @cart, include: { cart_items: { include: :product_item } }
  end

  private

  def set_cart
    @cart = Cart.find_or_create_by(user: @current_user)
  end
end
