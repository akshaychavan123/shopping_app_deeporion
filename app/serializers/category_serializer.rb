class CategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :subcategories

  def subcategories
    ordered_subcategories = object.subcategories.order(created_at: :asc)
    ActiveModelSerializers::SerializableResource.new(ordered_subcategories, each_serializer: SubcategorySerializer)
  end
end