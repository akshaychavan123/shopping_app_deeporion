class Api::V1::ReviewsController < ApplicationController
  before_action :authorize_request, only: :create
  before_action :set_current_user, only: [:index]

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
    review_summary = calculate_review_summary(@product_item.id)
    render json: {
      reviews: ActiveModelSerializers::SerializableResource.new(@reviews, each_serializer: Review2Serializer, current_user: @current_user),
      summary: review_summary
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

  def calculate_review_summary(product_item_id)
    reviews = Review.where(product_item_id: product_item_id)
    {
      total_review_count: reviews.count,
      average_rating: reviews.average(:star).to_f,
      one_star_count: reviews.where(star: 1).count,
      two_star_count: reviews.where(star: 2).count,
      three_star_count: reviews.where(star: 3).count,
      four_star_count: reviews.where(star: 4).count,
      five_star_count: reviews.where(star: 5).count
    }
  end
end
