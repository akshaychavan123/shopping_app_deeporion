class ProductItemVariantSerializer < ActiveModel::Serializer
  attributes :id, :price, :product_item_id, :size, :in_stock
  # belongs_to :product_item, serializer: ProductItemSerializer
  # has_many :sizes, serializer: SizeSerializer
end
