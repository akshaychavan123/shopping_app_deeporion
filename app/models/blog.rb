class Blog < ApplicationRecord
  validates :path_name, presence: true, uniqueness: true

  def self.ransackable_attributes(auth_object = nil)
    %w[ path_name ]
  end
end
