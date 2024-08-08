class CareerRole < ApplicationRecord
  belongs_to :career

  validates :role_name, :role_type, :location, :role_overview, :key_responsibility, :requirements, :email_id, presence: true
end
