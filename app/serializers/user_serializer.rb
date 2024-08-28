class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :phone_confirmed, :phone_number, :phone_verification_code, :type,
  :full_phone_number, :country_code, :phone_verification_code_sent_at, :uid, 
  :provider, :terms_and_condition, :image, :bio, :facebook, :linkedin, :instagram, :youtube, :password_digest
  
  has_many :addresses, serializer: AddressSerializer, if: -> { object.addresses.any? }

  def addresses
    [object.addresses.first]
  end

  def image
    if object.image.attached?
      if Rails.env.development? || Rails.env.test?
        "#{base_url}#{Rails.application.routes.url_helpers.rails_blob_path(object.image, only_path: true)}"
      else
        object.image.service.send(:object_for, object.image.key).public_url
      end
    end
  end


  private

  def base_url
    ENV['BASE_URL'] || 'http://localhost:3000'
  end            
end
