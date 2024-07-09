class GiftCardSerializer < ActiveModel::Serializer
  attributes :id, :price, :images

  def images
    object.images.map do |image|
      {
        url: "#{base_url}#{Rails.application.routes.url_helpers.rails_blob_path(image, only_path: true)}"
      }
    end
  end

  private

  def base_url
    ENV['BASE_URL'] || 'http://localhost:3000'
  end
end
  