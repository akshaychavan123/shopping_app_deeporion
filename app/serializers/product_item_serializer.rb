class ProductItemSerializer < ActiveModel::Serializer
  attributes :id, :name, :brand, :price, :discounted_price, :discount_percent, :is_tax_inclusive, :image, :photos, 
             :expected_delivery, :product_code, :payment_method, :is_favorite, :product_id, :productdetails, :specification

  has_many :product_item_variants, serializer: ProductItemVariantSerializer

  def reviews
    ActiveModelSerializers::SerializableResource.new(object.reviews, each_serializer: ReviewSerializer)
  end


  def productdetails
    {
      care_instructions: object.care_instructions,
      size_and_fit: object.size_and_fit,
      description: object.description
    }
  end

  def specification
    {
      material: object.material,
      fabric: object.fabric,
      hemline: object.hemline,
      neck: object.neck,
      textile_thread: object.texttile_thread,
      main_trend: object.main_trend,
      knite_or_woven: object.knite_or_woven,
      length: object.length,
      occasion: object.occasion,
      color: object.color
    }
  end

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
    "#{discount}% off"
  end

  def is_tax_inclusive
    nil
  end

  def payment_method
    nil
  end

  private

  def base_url
    ENV['BASE_URL'] || 'http://localhost:3000'
  end   
  
  def current_user
    @instance_options[:current_user]
  end
end
