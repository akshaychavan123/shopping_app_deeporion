class ProductItemSerializer < ActiveModel::Serializer
  attributes :id, :name, :brand, :price, :description, :material, :care, :product_code, :product_id, :image, :product_item_variants
  has_many :product_item_variants, serializer: ProductItemVariantSerializer

  def image
    object.image.attached? ? "#{base_url}#{Rails.application.routes.url_helpers.rails_blob_path(object.image, only_path: true)}" : nil
  end

  private

  def base_url
    ENV['BASE_URL'] || 'http://localhost:3000'
  end      
end
