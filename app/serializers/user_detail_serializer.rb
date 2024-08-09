class UserDetailSerializer < ActiveModel::Serializer
	attributes :id, :name, :email, :phone_number, :password_digest, :image

  def image
    object.image.attached? ? "#{base_url}#{Rails.application.routes.url_helpers.rails_blob_path(object.image, only_path: true)}" : nil
  end

  private

  def base_url
    ENV['BASE_URL'] || 'http://localhost:3000'
  end         
end
