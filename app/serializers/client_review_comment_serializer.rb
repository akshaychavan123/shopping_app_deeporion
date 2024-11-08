class ClientReviewCommentSerializer < ActiveModel::Serializer
  attributes :id, :comment, :client_review_id, :admin_name, :admin_image

  def admin_name
    object.user.name
  end

  def admin_image
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

  belongs_to :client_review

  private

  def base_url
    ENV['BASE_URL'] || 'http://localhost:3000'
  end
end
