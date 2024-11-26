class Api::V1::ReviewVotesController < ApplicationController
  before_action :authorize_request

  def create
    @review = Review.find(params[:review_id])
    @review_vote = @review.review_votes.find_or_initialize_by(user: @current_user)

    if @review_vote.persisted? && @review_vote.helpful == params[:helpful]
      @review_vote.destroy
      helpful_true_count = @review.review_votes.where(helpful: true).count
      helpful_false_count = @review.review_votes.where(helpful: false).count
      render json: { message: 'Vote removed', helpful_true_count: helpful_true_count, helpful_false_count: helpful_false_count }, status: :ok
    else

      if @review_vote.update(review_vote_params)
        helpful_true_count = @review.review_votes.where(helpful: true).count
        helpful_false_count = @review.review_votes.where(helpful: false).count
        render json: { review_vote: @review_vote, helpful_true_count: helpful_true_count, helpful_false_count: helpful_false_count }, status: :created
      else
        render json: @review_vote.errors, status: :unprocessable_entity
      end
    end
  end

  private

  def review_vote_params
    params.permit(:helpful)
  end
end
