class Api::V2::GiftCardCategoriesController < ApplicationController
  before_action :authorize_request
  before_action :check_user
  before_action :set_gift_card_category, only: [:show, :destroy]

  def index
    @gift_card_categories = GiftCardCategory.all
    render json: { data: ActiveModelSerializers::SerializableResource.new(@gift_card_categories, each_serializer: GiftCardCategorySerializer)}
  end

  def show
    render json: { data: ActiveModelSerializers::SerializableResource.new(@gift_card_category, each_serializer: GiftCardCategorySerializer)}
  end

  def create
    @gift_card_category = GiftCardCategory.new(gift_card_category_params)

    if @gift_card_category.save
      if params[:image].present?
        @gift_card_category.image.attach(params[:image])
      end
      render json: @gift_card_category, serializer: GiftCardCategorySerializer, status: :created
    else
      render json: @gift_card_category.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @gift_card_category.destroy
    render json: { message: 'GiftCardCategory successfully deleted' }, status: :ok
  end

  private

  def set_gift_card_category
    @gift_card_category = GiftCardCategory.find(params[:id])
  end

  def gift_card_category_params
    params.permit(:title)
  end

  def check_user
    unless @current_user.type == "Admin"
      render json: { errors: ['Unauthorized access'] }, status: :forbidden
    end
  end
end
