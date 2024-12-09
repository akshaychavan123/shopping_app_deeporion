class Plan < ApplicationRecord
  has_many :subscriptions, dependent: :destroy

  enum period: {
    daily: 'daily',
    weekly: 'weekly',
    monthly: 'monthly',
    yearly: 'yearly'
  }

  validates :razorpay_plan_id, :name, :description, :amount, :currency, :interval, presence: true
end
