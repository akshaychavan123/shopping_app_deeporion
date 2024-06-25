class Api::V2::GiftCardCategoriesController < ApplicationController
  before_action :authorize_request
  before_action :set_gift_card_category, only: [:show, :destroy]

  def index
    @gift_card_categories = GiftCardCategory.all
    render json: @gift_card_categories
  end

  def show
    render json: @gift_card_category
  end

  def create
    @gift_card_category = GiftCardCategory.new(gift_card_category_params)

    if @gift_card_category.save
      render json: @gift_card_category, status: :created
    else
      render json: @gift_card_category.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @gift_card_category.destroy
    head :no_content
  end

  private

  def set_gift_card_category
    @gift_card_category = GiftCardCategory.find(params[:id])
  end

  def gift_card_category_params
    params.require(:gift_card_category).permit(:title)
  end
end
