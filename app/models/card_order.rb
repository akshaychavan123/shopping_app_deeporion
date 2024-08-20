class CardOrder < ApplicationRecord
  belongs_to :gift_card
  validates :recipient_name, :recipient_email, :sender_email, presence: true
  validates :recipient_email, :sender_email, format: { with: URI::MailTo::EMAIL_REGEXP }
end
