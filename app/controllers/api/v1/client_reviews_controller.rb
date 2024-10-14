class Api::V1::ClientReviewsController < ApplicationController
  before_action :authorize_request, only: :create

  def index
    if params[:star].present?
      @client_reviews = ClientReview.where(star: params[:star]).order(created_at: :desc)
    else
      @client_reviews = ClientReview.order(created_at: :desc)
    end
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
  
  private

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
