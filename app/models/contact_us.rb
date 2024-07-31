class ContactUs < ApplicationRecord
  validates :name, presence: true
  validates :email, presence: true
  validates :contact_number, presence: true
  validates :details, presence: true
end
