class WishlistItemSerializer < ActiveModel::Serializer
  attributes :id, :product_item_variant

  belongs_to :product_item_variant, serializer: ProductItemVariantSerializer
end
