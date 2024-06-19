class Api::V1::WishlistsController < ApplicationController
  before_action :authorize_request
  def show
    @wishlist = Wishlist.find_by(user_id: params[:user_id])
    render json: @wishlist, include: :product_items
  end
end