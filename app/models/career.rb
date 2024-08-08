class Career < ApplicationRecord
  has_many :career_roles, dependent: :destroy
  accepts_nested_attributes_for :career_roles, allow_destroy: true

  validates :header, presence: true
end
