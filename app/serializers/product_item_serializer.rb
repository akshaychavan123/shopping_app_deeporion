class ProductItemSerializer < ActiveModel::Serializer
  attributes :id, :name, :brand, :price, :discounted_price, :discount_percent, :description, :material, :care, :product_code, :product_id, :is_favorite, :care_instructions, :fabric, :hemline, :neck, :texttile_thread, :size_and_fit, :main_trend, :knite_or_woven, :length, :occasion, :expected_delivery, :image, :photos, :product_item_variants, :reviews
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

  def expected_delivery
    start_date = Date.today
    end_date = start_date + 7.days
    "Get it by #{end_date.strftime('%A, %B %d, %Y')}"
  end

  def discount_percent
    return nil unless object.respond_to?(:discounted_price) && object.discounted_price.present?

    discount = ((object.price - object.discounted_price) / object.price * 100).round(2)
    "#{discount}%off"
  end

  private

  def base_url
    ENV['BASE_URL'] || 'http://localhost:3000'
  end   
  
  def current_user
    @instance_options[:current_user]
  end
end