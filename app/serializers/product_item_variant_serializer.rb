class ProductItemVariantSerializer < ActiveModel::Serializer
  attributes :id, :price, :product_item_id, :size, :in_stock, :discounted_price, :discount_percent

  def discounted_price
    object.discounted_price.present? ? object.discounted_price : object.price
  end
end