class Api::V1::ClientReviewsController < ApplicationController
  before_action :authorize_request, only: [:create, :update, :destroy]
  before_action :set_client_review, only: [:update, :destroy]

  def index
      @client_reviews = ClientReview.includes(:client_review_comment).order(created_at: :desc)  
      @client_reviews = @client_reviews.page(params[:page]).per(params[:per_page])

    render json: {
      client_reviews: ActiveModelSerializers::SerializableResource.new(@client_reviews, each_serializer: ClientReviewSerializer),
      meta: pagination_meta(@client_reviews)
    }, status: :ok
  end

  def create
    @client_review = ClientReview.new(client_review_params)
    @client_review.user = @current_user
  
    if @client_review.save
      render json: @client_review, serializer: ClientReviewSerializer, status: :created
    else
      render json: @client_review.errors, status: :unprocessable_entity
    end
  end

  def update
    if @client_review.user == @current_user
      if @client_review.update(client_review_params)
        render json: @client_review, serializer: ClientReviewSerializer, status: :ok
      else
        render json: @client_review.errors, status: :unprocessable_entity
      end
    else
      render json: { error: 'You are not authorized to update this review' }, status: :forbidden
    end
  end
  
  def destroy
    if @client_review.user == @current_user
      @client_review.destroy
      render json: { message: 'Review was successfully deleted.' }, status: :ok
    else
      render json: { error: 'You are not authorized to delete this review' }, status: :forbidden
    end
  end

  private

  def set_client_review
    @client_review = ClientReview.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Review not found' }, status: :ok
  end
  
  def client_review_params
    params.require(:client_review).permit(:star, :review)
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
