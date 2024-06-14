class Api::V1::WishlistItemsController < ApplicationController
	before_action :authorize_request
	def create
		@wishlist = Wishlist.find(params[:wishlist_id])
		@product_item = ProductItem.find(params[:product_item_id])
		@wishlist_item = @wishlist.wishlist_items.build(product_item: @product_item)

		if @wishlist_item.save
			render json: @wishlist_item, status: :created
		else
			render json: @wishlist_item.errors, status: :unprocessable_entity
		end
	end

	def destroy
		@wishlist_item = WishlistItem.find(params[:id])
		@wishlist_item.destroy
		head :no_content
	end
end
