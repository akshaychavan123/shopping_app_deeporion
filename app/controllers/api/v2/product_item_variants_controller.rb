class Api::V2::ProductItemVariantsController < ApplicationController
  before_action :authorize_request
  before_action :check_user
  before_action :product_item_variant_params, only: :create

  def create
    @product_item_variant = ProductItemVariant.new(product_item_variant_params)

    begin
      if @product_item_variant.save
        if params[:data][:photos].present?
          Array(params[:data][:photos]).each do |photo|
            @product_item_variant.photos.attach(photo)
          end
        end
        render json: { data: ActiveModelSerializers::SerializableResource.new(@product_item_variant, serializer: ProductItemVariantSerializer) }, status: :created
      else
        render json: { errors: @product_item_variant.errors.full_messages }, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordNotUnique => e
      render json: { errors: ["A product item variant with the same size name already exists."] }, status: :unprocessable_entity
    end
  end

  private

  def product_item_variant_params
    params.require(:data).permit(
      :color, :size, :price, :product_item_id,
      sizes_attributes: [:size_name, :price, :quantity, :_destroy]
    )
  end

  def check_user
    unless @current_user.type == "Admin"
      render json: { errors: ['Unauthorized access'] }, status: :forbidden
    end
  end
end
