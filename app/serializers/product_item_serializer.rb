class ProductItemSerializer < ActiveModel::Serializer
  attributes :name, :brand, :description, :material, :care, :product_code, :product_id
  has_many :product_item_variants
end
