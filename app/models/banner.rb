class Banner < ApplicationRecord
  has_many_attached :images

  validates :heading, :description, :banner_type, presence: true
end
