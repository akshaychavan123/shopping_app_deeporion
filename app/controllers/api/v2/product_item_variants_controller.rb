class Api::V2::ProductItemVariantsController < ApplicationController
  before_action :authorize_request
  before_action :check_user
  before_action :product_item_variant_params, only: :create

  def create
    @product_item_variant = ProductItemVariant.new(product_item_variant_params)

    if @product_item_variant.save
      render json: { data: ActiveModelSerializers::SerializableResource.new(@product_item_variant, serializer: ProductItemVariantSerializer) }, status: :created
    else
      render json: { errors: @product_item_variant.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @product_item_variant = ProductItemVariant.find_by(id: params[:id])
    if @product_item_variant.update(product_item_variant_params)
      render json: { data: ActiveModelSerializers::SerializableResource.new(@product_item_variant, each_serializer: ProductItemVariantSerializer)}
    else
      render json: @product_item_variant.errors, status: :unprocessable_entity
    end
  end

  private

  def product_item_variant_params
    params.permit(
      :color, :size, :price, :product_item_id, :quantity, :in_stock
    )
  end

  def check_user
    unless @current_user.type == "Admin"
      render json: { errors: ['Unauthorized access'] }, status: :forbidden
    end
  end
end
