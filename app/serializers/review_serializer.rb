class ReviewSerializer < ActiveModel::Serializer
  attributes :id, :user_name, :user_image, :star, :review

  def user_image
    user = object.user
    user.image.attached? ? "#{base_url}#{Rails.application.routes.url_helpers.rails_blob_path(user.image, only_path: true)}" : nil
  end

  def user_name
    object.user.name
  end

  private

  def base_url
    ENV['BASE_URL'] || 'http://localhost:3000'
  end
end
