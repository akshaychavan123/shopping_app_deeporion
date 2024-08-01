class Api::V1::ReviewsController < ApplicationController
  before_action :authorize_request, only: :create
  before_action :set_product_item, only: [:create, :index]

  def create
    @product = ProductItem.find(params[:product_item_id])
    @review = @product_item.reviews.new(review_params)
    @review.user = @current_user

    if @review.save
      render json: @review, status: :created
    else
      render json: @review.errors, status: :unprocessable_entity
    end
  end

  
  def index
    @reviews = @product_item.reviews

    render json: @reviews
  end

  private

  def set_product_item
    @product_item = ProductItem.find(params[:product_item_id])
  end

  def review_params
    params.permit(:star, :recommended, :review)
  end
end
