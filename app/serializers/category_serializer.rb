class CategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :subcategories

  has_many :subcategories, serializer: SubcategorySerializer
end