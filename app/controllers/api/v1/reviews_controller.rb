class Api::V1::ReviewsController < ApplicationController
  before_action :authorize_request, only: [:create, :update, :destroy]
  before_action :set_review, only: [:update, :destroy]
  before_action :set_product_item, only: [:create, :index]

  def index
    @reviews = @product_item.reviews.includes(:review_votes).where(deleted_at: nil).order(created_at: :desc)
  
    case params[:filter]
    when 'popular'
      @reviews = @reviews.left_joins(:review_votes)
                         .group('reviews.id')
                         .having('COUNT(review_votes.id) > 0')
                         .order(created_at: :desc)
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
    
      if params[:images].present?
        Array(params[:images]).each do |image|
          @review.images.attach(image) 
        end
      end
  
      if params[:videos].present?
        Array(params[:videos]).each do |video|
          @review.videos.attach(video) 
        end
      end
   
    if @review.save
      render json: {
        reviews: ActiveModelSerializers::SerializableResource.new(@review, serializer: Review2Serializer)
      }, status: :created
    else
      render json: { errors: @review.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @review.user != @current_user
      render json: { error: 'You are not authorized to update this review' }, status: :forbidden
      return
    end

    if params[:images].present?
      @review.images.purge
      Array(params[:images]).each { |image| @review.images.attach(image) }
    end

    if params[:videos].present?
      @review.videos.purge
      Array(params[:videos]).each { |video| @review.videos.attach(video) }
    end

    if @review.update(review_params)
      render json: {
        message: 'Review updated successfully',
        review: ActiveModelSerializers::SerializableResource.new(@review, serializer: Review2Serializer)
      }, status: :ok
    else
      render json: { errors: @review.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @review.user != @current_user
      render json: { error: 'You are not authorized to delete this review' }, status: :forbidden
      return
    end

    @review.destroy
    render json: { message: 'Review deleted successfully' }, status: :ok
  end
  
  private

  def set_product_item
    @product_item = ProductItem.find(params[:product_item_id])
  end

  def set_review
    @review = Review.find_by(id: params[:id])

    unless @review
      render json: { error: 'Review not found' }, status: :not_found
    end
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
