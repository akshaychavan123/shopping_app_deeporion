class ProductItem3Serializer < ActiveModel::Serializer
  attributes :id, :name, :brand, :image, :product_item_variants

  def product_item_variants
    ActiveModelSerializers::SerializableResource.new(object.product_item_variants, each_serializer: ProductItemVariantSerializer)
  end
  
  def image
    object.image.attached? ? "#{base_url}#{Rails.application.routes.url_helpers.rails_blob_path(object.image, only_path: true)}" : nil
  end

  private

  def base_url
    ENV['BASE_URL'] || 'http://localhost:3000'
  end      
end
