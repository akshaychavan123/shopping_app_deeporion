class Blog < ApplicationRecord
  has_one_attached :card_image
  has_one_attached :banner_image
  has_one_attached :card_home_image
  # validates :path_name, presence: true, uniqueness: true
end
