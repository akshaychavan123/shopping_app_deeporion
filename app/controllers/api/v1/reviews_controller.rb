class Api::V1::ReviewsController < ApplicationController
  before_action :authorize_request, only: :create
  before_action :set_product_item, only: [:create, :index]

  def create
    @review = @product_item.reviews.new(review_params)
    @review.user = @current_user

    if @review.save
      render json: @review, status: :created
    else
      render json: @review.errors, status: :unprocessable_entity
    end
  end

  
  def index
    @reviews = @product_item.reviews.includes(:review_votes)
    render json: {
    data: ActiveModelSerializers::SerializableResource.new(@reviews, each_serializer: Review2Serializer)
  }
  end
  

  def show_all_review
    @reviews = Review.all.page(params[:page]).per(params[:per_page])
    render json: {
      data: ActiveModelSerializers::SerializableResource.new(@reviews, each_serializer: ReviewSerializer),
      meta: pagination_meta(@reviews)
    }
  end

  private

  def set_product_item
    @product_item = ProductItem.find(params[:product_item_id])
  end

  def review_params
    params.permit(:star, :recommended, :review)
  end

  def pagination_meta(collection)
    {
      current_page: collection.current_page,
      next_page: collection.next_page,
      prev_page: collection.prev_page,
      total_pages: collection.total_pages,
      total_count: collection.total_count
    }
  end
end
