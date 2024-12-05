class WishlistItemSerializer < ActiveModel::Serializer
  attributes :id, :product_item_id, :product_item_name, :product_item_brand, :price_of_first_variant, :discounted_price_of_first_variant, :discount_percent_of_first_variant, :rating_and_review, :image, :product_item_stock_status

  def product_item_id
    object.product_item_id
  end

  def product_item_name
    object.product_item.name
  end

  def product_item_brand
    object.product_item.brand
  end

  def price_of_first_variant
    object.product_item.product_item_variants&.first&.price
  end

  def discounted_price_of_first_variant
    object.product_item.product_item_variants&.first&.discounted_price
  end

  def discount_percent_of_first_variant
    object.product_item.product_item_variants&.first&.discount_percent
  end

  def product_item_stock_status
    object.product_item&.in_stock
  end

  def image
    if object.product_item.image.attached?
      if Rails.env.development? || Rails.env.test?
        "#{base_url}#{Rails.application.routes.url_helpers.rails_blob_path(object.product_item.image, only_path: true)}"
      else
        object.product_item.image.service.send(:object_for, object.product_item.image.key).public_url
      end
    end
  end

  def rating_and_review
    reviews = Review.where(product_item_id: object.product_item.id)
    {
      total_review_count: reviews.count,
      average_rating: reviews.average(:star).to_f,
    }    
  end

  private

  def base_url
    ENV['BASE_URL'] || 'http://localhost:3000'
  end
end
