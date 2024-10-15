class Review2Serializer < ActiveModel::Serializer
	attributes :id, :star, :recommended, :review, :helpful_true_count, :helpful_false_count, :total_review_count, :created_time, :user_review_voted
  include ActionView::Helpers::DateHelper

  def helpful_true_count
    object.review_votes.where(helpful: true).count
  end

  def helpful_false_count
    object.review_votes.where(helpful: false).count
  end

  def total_review_count
    Review.where(product_item_id: object.product_item_id).count
  end

  def created_time
    time_ago_in_words(object.created_at)
  end

  def user_review_voted
    return nil unless current_user.present?
    user_review_vote = object.review_votes.find_by(user_id: current_user.id)

    if user_review_vote.present?
      true
    else
      false
    end
  end
  private

  def time_ago_in_words(from_time, include_seconds = false)
    distance_of_time_in_words(from_time, Time.current, include_seconds: include_seconds)
  end

  def current_user
    @instance_options[:current_user]
  end
end
