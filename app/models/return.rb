class Return < ApplicationRecord
  belongs_to :order
  belongs_to :order_item
  belongs_to :address

  validates :reason, presence: true
end
