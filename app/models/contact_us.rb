class ContactUs < ApplicationRecord
  validates :name, presence: true
  validates :email, presence: true
  validates :contact_number, presence: true
  validates :details, presence: true

  enum status: {
    in_progress: "in_progress",
    resolved: "resolved" }
end
