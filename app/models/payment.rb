class Payment < ApplicationRecord
  belongs_to :user
  belongs_to :subscription, optional: true  # Optional, as not all payments may relate to subscriptions

  validates :payment_id, presence: true, uniqueness: true
  validates :order_id, :status, presence: true
  
end
