class ProductItemSerializer < ActiveModel::Serializer
  attributes :id, :name, :brand, :is_tax_inclusive, :image, :photos, :height,
             :expected_delivery, :product_code, :payment_method, :is_favorite, :product_id, :productdetails, :specification,:created_at, :in_stock

  has_many :product_item_variants, serializer: ProductItemVariantSerializer

  def reviews
    ActiveModelSerializers::SerializableResource.new(object.reviews, each_serializer: ReviewSerializer)
  end

  def productdetails
    {
      material_and_care: object.care_instructions,
      size_and_fit: object.size_and_fit.to_s + " " + object.height.to_s,
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
    if object.image.attached?
      host = base_url
      Rails.env.development? || Rails.env.test? ?
        "#{host}#{Rails.application.routes.url_helpers.rails_blob_path(object.image, only_path: true)}" :
        object.image.service.send(:object_for, object.image.key).public_url
    end
  end

  def photos
    host = base_url
    object.photos.map do |photo|
      Rails.env.development? || Rails.env.test? ?
        "#{host}#{Rails.application.routes.url_helpers.rails_blob_path(photo, only_path: true)}" :
        photo.service.send(:object_for, photo.key).public_url
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
