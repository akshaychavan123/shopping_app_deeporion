class Api::V1::WishlistsController < ApplicationController
  before_action :authorize_request

  def show_wishlistitems
    @wishlist_items = @current_user.wishlist.wishlist_items.includes(product_item_variant: :product_item)
    
    if @wishlist_items.any?
      render json: { data: ActiveModelSerializers::SerializableResource.new(@wishlist_items, each_serializer: WishlistItemSerializer) }
    else
      render json: { errors: ['Wishlist not found'] }, status: :not_found
    end
  end
end