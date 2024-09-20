class Address < ApplicationRecord
  belongs_to :user

  validates :first_name, :last_name, :phone_number, :email, :country, :pincode, :area, :state, :address, :city, :address_type, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone_number, format: { with: /\A\+?\d{10,15}\z/ }

  def full_address
    "#{address}, #{area}, #{city}, #{state}, #{country} - #{pincode}"
  end
end
