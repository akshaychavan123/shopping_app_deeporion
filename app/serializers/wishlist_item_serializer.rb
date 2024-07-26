class WishlistItemSerializer < ActiveModel::Serializer
  attributes :id, :product_item_id, :product_item_name, :product_item_brand, :price_of_variant, :id_of_first_variant, :one_image_of_variant, :rating_and_review

  def product_item_id
    object.product_item.id
  end

  def product_item_name
    object.product_item.name
  end

  def product_item_brand
    object.product_item.brand
  end

  def price_of_variant
    first_variant&.price
  end

  def id_of_first_variant
    first_variant&.id
  end

  def one_image_of_variant
    if first_variant.present? && first_variant.photos.attached?
      "#{base_url}#{Rails.application.routes.url_helpers.rails_blob_url(first_variant.photos.first, only_path: true)}"
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

  def first_variant
    @first_variant ||= object.product_item.product_item_variants.first
  end
end
