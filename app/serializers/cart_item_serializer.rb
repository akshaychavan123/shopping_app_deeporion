class CartItemSerializer < ActiveModel::Serializer
  attributes :id, :quantity, :size#, :product_item :quantity#, :product_item_id#, :product_item_name, :product_item_brand, :price_of_product, :rating_and_review, :image
  belongs_to :product_item, serializer: ProductItem3Serializer
  # belongs_to :product_item_variant

  def size
    object.product_item_variant&.size
  end
  
  def product_item_name
    object.product_item.name
  end

  def product_item_brand
    object.product_item.brand
  end

  def price_of_product
    object.product_item.price
  end

  def image
    if object.product_item.image.attached?
      "#{base_url}#{Rails.application.routes.url_helpers.rails_blob_path(object.product_item.image, only_path: true)}"
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
