class ProductItemSerializer < ActiveModel::Serializer
  attributes :id, :name, :brand, :description, :material, :care, :product_code, :product_id
  has_many :product_item_variants
end
