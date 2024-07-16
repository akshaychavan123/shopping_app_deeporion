class ProductItemSerializer < ActiveModel::Serializer
  attributes :id, :name, :brand, :discounted_price, :description, :material, :care, :product_code, :product_id
  has_many :product_item_variants
end
