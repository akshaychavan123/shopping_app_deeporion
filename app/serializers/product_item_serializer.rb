class ProductItemSerializer < ActiveModel::Serializer
  attributes :id, :name, :brand, :discounted_price, :description, :material, :care, :product_code, :product_id
  has_many :product_item_variants

  # def images
  #   object.images.map do |image|
  #     "#{base_url}#{Rails.application.routes.url_helpers.rails_blob_path(image, only_path: true)}"
  #   end
  # end

  # private

  # def base_url
  #   ENV['BASE_URL'] || 'http://localhost:3000'
  # end
end
