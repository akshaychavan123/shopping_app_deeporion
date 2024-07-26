class ProductItemVariantSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :color, :price, :photos
  # belongs_to :product_item, serializer: ProductItemSerializer
  has_many :sizes, serializer: SizeSerializer

  def photos
    object.photos.map do |photo|
      "#{base_url}#{Rails.application.routes.url_helpers.rails_blob_path(photo, only_path: true)}"
    end
  end

  private

  def base_url
    ENV['BASE_URL'] || 'http://localhost:3000'
  end
end
