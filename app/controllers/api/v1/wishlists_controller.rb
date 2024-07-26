class Api::V1::WishlistsController < ApplicationController
  before_action :authorize_request

  def show_wishlistitems
    @wishlist_items = @current_user.wishlist.wishlist_items.includes(product_item: :product_item_variants)
    
    if @wishlist_items.any?
      render json: { data: ActiveModelSerializers::SerializableResource.new(@wishlist_items, each_serializer: WishlistItemSerializer) }
    else
      render json: { errors: ['Wishlist not found'] }, status: :not_found
    end
  end
end