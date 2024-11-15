class AdminReviewSerializer < ActiveModel::Serializer
  attributes :id, :reviewer_name, :reviewer_image, :star, :review, :images_and_videos, 
             :helpful_true_count, :helpful_false_count, :total_review_count, 
             :created_time

  include ActionView::Helpers::DateHelper

  def reviewer_name
    object.user&.name
  end

  def reviewer_image
    return unless object.user&.image&.attached?

    host = base_url
    Rails.env.development? || Rails.env.test? ?
      "#{host}#{Rails.application.routes.url_helpers.rails_blob_path(object.user.image, only_path: true)}" :
      object.user.image.service_url
  end

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

  def images_and_videos
    host = base_url
    object.images_and_videos.map do |media|
      Rails.env.development? || Rails.env.test? ?
        "#{host}#{Rails.application.routes.url_helpers.rails_blob_path(media, only_path: true)}" :
        media.service_url
    end
  end

  private

  def base_url
    ENV['BASE_URL'] || 'http://localhost:3000'
  end
end
