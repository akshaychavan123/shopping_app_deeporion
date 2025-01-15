class CareerRole < ApplicationRecord
  belongs_to :career

  validates :role_name, :role_type, :location, :role_overview, :key_responsibility, :requirements, :email_id, presence: true
  def self.ransackable_attributes(_auth_object = nil)
    %w[role_name role_type location email_id]
  end

  
  def self.ransackable_associations(_auth_object = nil)
    %w[career]
  end
end
