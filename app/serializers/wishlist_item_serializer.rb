class WishlistItemSerializer < ActiveModel::Serializer
  attributes :id, :product_item_variant_id, :product_item_name, :product_item_brand, :price_of_variant, :one_image_of_variant, :rating_and_review

  def product_item_variant_id
    object.product_item_variant_id
  end

  def product_item_name
    object.product_item_variant.product_item.name
  end

  def product_item_brand
    object.product_item_variant.product_item.brand
  end

  def price_of_variant
    object.product_item_variant.price
  end

  def one_image_of_variant
    if object.product_item_variant.photos.attached?
      "#{base_url}#{Rails.application.routes.url_helpers.rails_blob_path(object.product_item_variant.photos.first, only_path: true)}"
    else
      nil
    end
  end

  def rating_and_review
    nil
  end

  private

  def base_url
    ENV['BASE_URL'] || 'http://localhost:3000'
  end
end
