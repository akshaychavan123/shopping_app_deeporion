class SubcategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :category_id, :products

  def products
    ordered_products = object.products.order(created_at: :asc)
    ActiveModelSerializers::SerializableResource.new(ordered_products, each_serializer: ProductSerializer)
  end
end