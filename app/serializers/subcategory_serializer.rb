class SubcategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :category_id, :products

  def products
    ActiveModelSerializers::SerializableResource.new(object.products, each_serializer: ProductSerializer)
  end
end