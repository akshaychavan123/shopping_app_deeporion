class Api::V2::ProductItemVariantsController < ApplicationController
  before_action :authorize_request

  def create
    @product_item_variant = ProductItemVariant.new(product_item_variant_params)
    if @product_item_variant.save
      if params[:photos].present?
        Array(params[:photos]).each do |photo|
          @product_item_variant.photos.attach(photo)
        end
      end
      render json: { data: ActiveModelSerializers::SerializableResource.new(@product_item_variant, serializer: ProductItemVariantSerializer) }
    else
      render json: { errors: @product_item_variant.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def product_item_variant_params
    params.permit(:product_item_id, :color, :size, :price, :quantity, photos: [])
  end
end
