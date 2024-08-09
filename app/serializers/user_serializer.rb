class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :phone_confirmed, :phone_number, :phone_verification_code,
  :full_phone_number, :country_code, :phone_verification_code_sent_at, :uid, 
  :provider, :terms_and_condition, :image, :bio, :facebook, :linkedin, :instagram, :youtube, :password_digest
  has_one :address

  def image
    object.image.attached? ? "#{base_url}#{Rails.application.routes.url_helpers.rails_blob_path(object.image, only_path: true)}" : nil
  end

  private

  def base_url
    ENV['BASE_URL'] || 'http://localhost:3000'
  end            
end
