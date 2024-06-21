class User < ApplicationRecord
  has_secure_password
  
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }, unless: -> { phone_number.present? }
  validates :password, presence: true, length: { minimum: 6 }, unless: -> { phone_number.present? }
  validates :phone_number, presence: true, uniqueness: true, if: -> { phone_number.present? }
  validates :full_phone_number, uniqueness: true, if: -> { full_phone_number.present? }
  validates :uid, uniqueness: { scope: :provider }, if: -> { provider.present? }


  has_one :wishlist, dependent: :destroy
  has_one :cart, dependent: :destroy

  before_validation :parse_full_phone_number, if: -> { full_phone_number.present? }
  after_create :create_wishlist
  after_create :create_cart

  def phone_verification_code_expired?
    return true if phone_verification_code_sent_at.nil?
    phone_verification_code_sent_at < 1.minutes.ago
  end

  private

  def create_wishlist
    Wishlist.create(user: self)
  end

  def create_cart
    Cart.create(user: self)
  end  

  def parse_full_phone_number
    phone = Phonelib.parse(full_phone_number)
    self.full_phone_number = phone.sanitized
    self.country_code = phone.country_code
    self.phone_number = phone.national
  end
end
