class ClientReviewSerializer < ActiveModel::Serializer
  attributes :id, :star, :review, :user_name, :user_id, :user_image, :created_at, :created_time
  include ActionView::Helpers::DateHelper

  def user_name
    object.user.name
  end

  def user_id
    object.user_id
  end

  def user_image
    user = object.user
    host = base_url
    if user.image.attached?
      if Rails.env.development? || Rails.env.test?
        host + Rails.application.routes.url_helpers.rails_blob_path(user.image, only_path: true)
      else
        user.image.service.send(:object_for, user.image.key).public_url
      end
    else
      nil
    end
  end

  def created_time
    time_ago_in_words(object.created_at)
  end

  def created_at
    object.created_at.in_time_zone('Asia/Kolkata').strftime("%Y-%m-%d %H:%M:%S %Z")
  end

  has_one :client_review_comment  

  private

  def base_url
    ENV['BASE_URL'] || 'http://localhost:3000'
  end

  def time_ago_in_words(from_time, include_seconds = false)
    distance_of_time_in_words(from_time, Time.current, include_seconds: include_seconds)
  end
end
