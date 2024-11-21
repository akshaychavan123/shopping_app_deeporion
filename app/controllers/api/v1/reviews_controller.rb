class Api::V1::ReviewsController < ApplicationController
  before_action :authorize_request, only: :create
  before_action :set_current_user, only: [:index]

  before_action :set_product_item, only: [:create, :index]

  def index
    @reviews = @product_item.reviews.includes(:review_votes).where(deleted_at: nil)
  
    case params[:filter]
    when 'popular'
      @reviews = @reviews.left_joins(:review_votes)
                         .group('reviews.id')
                         .having('COUNT(review_votes.id) > 0')
                         .order('COUNT(review_votes.id) DESC, reviews.created_at DESC')
    when 'latest'
      @reviews = @reviews.order(created_at: :desc)
    when 'my_reviews'
      @reviews = @reviews.where(user: @current_user).order(created_at: :desc)
    end
  
    case params[:sort_by]
    when 'positive'
      @reviews = @reviews.where(star: 5)
    when 'negative'
      @reviews = @reviews.where(star: 1)
    when 'recent'
      @reviews = @reviews.order(created_at: :desc).limit(5)
    end
  
    @reviews = @reviews.page(params[:page]).per(params[:per_page])  
    review_summary = calculate_review_summary(@product_item.id)

    render json: {
      reviews: ActiveModelSerializers::SerializableResource.new(@reviews, each_serializer: Review2Serializer, current_user: @current_user),
      summary: review_summary,
      meta: pagination_meta(@reviews)
    }
  end

  def create
    @review = @product_item.reviews.new(review_params)
    @review.user = @current_user
  
    if @review.save

      if params[:images_and_videos].present?
        Array(params[:images_and_videos]).each do |media|
          @review.images_and_videos.attach(media)
        end
      end
  
      render json: { 
        reviews: ActiveModelSerializers::SerializableResource.new(@review, serializer: Review2Serializer)
      }, status: :created
    else
      render json: { errors: @review.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  private

  def set_product_item
    @product_item = ProductItem.find(params[:product_item_id])
  end

  def review_params
    params.permit(:star, :review)
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
