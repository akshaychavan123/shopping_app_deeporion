class CartItemSerializer < ActiveModel::Serializer
	attributes :id, :quantity
	belongs_to :product_item_variant, serializer: ProductItemVariantSerializer
end
