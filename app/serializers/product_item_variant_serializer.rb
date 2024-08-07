class ProductItemVariantSerializer < ActiveModel::Serializer
  attributes :id, :color, :price, :product_item_id, :size
  # belongs_to :product_item, serializer: ProductItemSerializer
  # has_many :sizes, serializer: SizeSerializer
end
