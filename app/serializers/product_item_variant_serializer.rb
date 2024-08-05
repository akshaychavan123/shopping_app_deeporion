class ProductItemVariantSerializer < ActiveModel::Serializer
  attributes :id, :color, :price, :quantity, :product_item_id
  # belongs_to :product_item, serializer: ProductItemSerializer
  # has_many :sizes, serializer: SizeSerializer
end
