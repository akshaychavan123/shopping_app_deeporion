class Api::V2::ClientReviewCommentsController < ApplicationController
  before_action :authorize_request
  before_action :check_user
  before_action :set_client_review_comment, only: [:show, :update, :destroy]

  def index
    client_reviews = ClientReview.includes(:client_review_comment).all
    render json: client_reviews, each_serializer: ClientReviewSerializer
  end

  def create
    @client_review = ClientReview.find_by(id: params[:client_review_id])
    
    if @client_review.nil?
      render json: { error: 'Review not found' }, status: :not_found
      return
    end
    
    if @client_review.client_review_comment.present?
      render json: { error: 'A comment already exists for this review' }, status: :unprocessable_entity
      return
    end

    comment = @client_review.build_client_review_comment(comment_params)
    comment.user = @current_user

    if comment.save
      render json: { message: 'Comment added successfully', comment: ClientReviewCommentSerializer.new(comment) }, status: :created
    else
      render json: { error: comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @client_review_comment.update(comment_params)
      render json: { message: 'Comment updated successfully', comment: ClientReviewCommentSerializer.new(@client_review_comment) }, status: :ok
    else
      render json: { error: @client_review_comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @client_review_comment.destroy
    render json: { message: 'Comment deleted successfully' }, status: :ok
  end

  private

  def set_client_review_comment
    @client_review_comment = ClientReviewComment.find_by(id: params[:id])
    
    if @client_review_comment.nil?
      render json: { error: 'Comment not found' }, status: :not_found
    end
  end

  def comment_params
    params.require(:client_review_comment).permit(:comment)
  end

  def check_user
    render json: { errors: ['Unauthorized access'] }, status: :forbidden unless @current_user.type == "Admin"
  end
end
