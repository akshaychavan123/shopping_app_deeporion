class GiftCardSerializer < ActiveModel::Serializer
  attributes :id, :price, :images, :gift_card_category_id, :expiry_date

  def images
    host = base_url
    object.images.map do |image|
      if Rails.env.development? || Rails.env.test?
        host + Rails.application.routes.url_helpers.rails_blob_path(image, only_path: true)
      else
        image.service.send(:object_for, image.key).public_url
      end
    end
  end

  def expiry_date
    "1 year from today"
  end  

  private

  def base_url
    ENV['BASE_URL'] || 'http://localhost:3000'
  end
end
