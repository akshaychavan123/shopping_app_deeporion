class ProductItem3Serializer < ActiveModel::Serializer
  attributes :id, :name, :brand, :price, :image#, :product_item_variants
  # has_many :product_item_variants, serializer: ProductItemVariantSerializer

  # has_many :product_item_variants, if: -> { instance_options[:selected_variants] } do
  #   instance_options[:selected_variants]
  # end
  
  def image
    object.image.attached? ? "#{base_url}#{Rails.application.routes.url_helpers.rails_blob_path(object.image, only_path: true)}" : nil
  end

  private

  def base_url
    ENV['BASE_URL'] || 'http://localhost:3000'
  end      
end
