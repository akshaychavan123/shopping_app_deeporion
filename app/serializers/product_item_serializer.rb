class ProductItemSerializer < ActiveModel::Serializer
  attributes :id, :name, :brand, :price, :discounted_price, :description, :size, :material, :care, :product_code, :product_id, :images

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
