class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :plan
  has_many :payments, dependent: :destroy

  validates :razorpay_subscription_id, :user_id, :plan_id, :start_date, :end_date, :status, presence: true

  enum status: {
    pending: 'pending',
    success: 'success',
    failed: 'failed',
    cancel: 'cancel'
  }
  
end
