class CardDetail < ApplicationRecord
  belongs_to :user
  validates :holder_name, presence: true
  validates :card_type, presence: true
  validates :card_number, presence: true, length: { in: 13..19 }, numericality: { only_integer: true }
  validate :expiry_date_cannot_be_in_the_past
  validates :cvv, presence: true, length: { in: 3..4 }, numericality: { only_integer: true }

  private

  def expiry_date_cannot_be_in_the_past
    if expiry_date.present?
      begin
        expiry = Date.strptime(expiry_date, '%m/%y').end_of_month
        if expiry < Date.today
          errors.add(:expiry_date, "can't be in the past")
        end
      rescue ArgumentError
        errors.add(:expiry_date, "is not a valid date")
      end
    end
  end  
end
