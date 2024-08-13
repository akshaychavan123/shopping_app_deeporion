class ProductItemSerializer < ActiveModel::Serializer
  attributes :id, :name, :brand, :price, :description, :material, :care, :product_code, :product_id, :is_favorite, :image, :photos, :product_item_variants, :reviews
  has_many :product_item_variants, serializer: ProductItemVariantSerializer

  def reviews
    ActiveModelSerializers::SerializableResource.new(object.reviews, each_serializer: ReviewSerializer)
  end


  def image
    object.image.attached? ? "#{base_url}#{Rails.application.routes.url_helpers.rails_blob_path(object.image, only_path: true)}" : nil
  end

  def photos
    object.photos.map do |photo|
      "#{base_url}#{Rails.application.routes.url_helpers.rails_blob_path(photo, only_path: true)}"
    end
  end

  def is_favorite
    return false unless current_user.present?
    current_user.wishlist&.wishlist_items.exists?(product_item_id: object.id)
  end

  private

  def base_url
    ENV['BASE_URL'] || 'http://localhost:3000'
  end   
  
  def current_user
    @instance_options[:current_user]
  end
end
