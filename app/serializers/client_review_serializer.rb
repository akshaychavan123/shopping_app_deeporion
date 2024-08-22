class ClientReviewSerializer < ActiveModel::Serializer
  attributes :id, :star, :review, :user_name, :user_image, :created_time
  include ActionView::Helpers::DateHelper

  def user_name
    object.user.name
  end

  def user_image
    user = object.user
    user.image.attached? ? "#{base_url}#{Rails.application.routes.url_helpers.rails_blob_path(user.image, only_path: true)}" : nil
  end

  def created_time
    time_ago_in_words(object.created_at)
  end

  private

  def base_url
    ENV['BASE_URL'] || 'http://localhost:3000'
  end


  def time_ago_in_words(from_time, include_seconds = false)
    distance_of_time_in_words(from_time, Time.current, include_seconds: include_seconds)
  end
end
