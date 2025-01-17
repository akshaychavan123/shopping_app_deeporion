class Blog < ApplicationRecord
  validates :path_name, presence: true, uniqueness: true
end
