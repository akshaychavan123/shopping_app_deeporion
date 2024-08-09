class CardDetail < ApplicationRecord
  belongs_to :user
  validates :holder_name, presence: true
  validates :card_number, presence: true, length: { in: 13..19 }, numericality: { only_integer: true }
  validates :expiry_date, presence: true, format: { with: /\A(0[1-9]|1[0-2])\/\d{4}\z/, message: "must be in the format MM/YYYY" }
  validate :expiry_date_cannot_be_in_the_past
  validates :cvv, presence: true, length: { in: 3..4 }, numericality: { only_integer: true }

  private

  def expiry_date_cannot_be_in_the_past
    if expiry_date.present?
      expiry = Date.strptime(expiry_date, '%m/%Y') rescue nil
      if expiry.nil? || expiry < Date.today.beginning_of_month
        errors.add(:expiry_date, "can't be in the past")
      end
    end
  end
end
