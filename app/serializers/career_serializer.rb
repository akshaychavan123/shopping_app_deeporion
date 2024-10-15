class CareerSerializer < ActiveModel::Serializer
  attributes :id, :header, :created_at, :updated_at
  has_many :career_roles
end
