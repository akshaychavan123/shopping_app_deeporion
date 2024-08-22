class Api::V1::ClientReviewsController < ApplicationController
  before_action :authorize_request, only: :create

  def index
    @client_reviews = ClientReview.order(star: :desc).page(params[:page]).per(params[:per_page])

    render json: {
      client_reviews: ActiveModelSerializers::SerializableResource.new(@client_reviews, each_serializer: ClientReviewSerializer),
      client_review_count:  @client_reviews.count
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
end
