class Coupon < ApplicationRecord
  has_one_attached :image
  has_many :coupon_usages, dependent: :destroy
  
  validates :promo_code_name, :promo_code, presence: true
  validates :promo_code, uniqueness: true
  validates :start_date, :end_date, :promo_type, presence: true
  validates :max_uses_per_client, :max_uses_per_promo, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :promo_type, inclusion: { in: ["discount on product", "discount on amount"], message: "%{value} is not a valid promo type" }
  validate :end_date_after_start_date

  private

  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?

    if end_date < start_date
      errors.add(:end_date, "must be after the start date")
    end
  end
end
