class CareerRoleSerializer < ActiveModel::Serializer
  attributes :id, :role_name, :role_type, :location, :role_overview, :key_responsibility, :requirements, :email_id, :created_at, :updated_at
end