class CategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :subcategories

  def subcategories
    ordered_categories = object.subcategories.order(created_at: :asc)
    ActiveModelSerializers::SerializableResource.new(ordered_categories, each_serializer: CategorySerializer)
  end
end
