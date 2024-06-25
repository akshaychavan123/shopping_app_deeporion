class User < ApplicationRecord
  has_secure_password

  # validates :password, format: { with: /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}\z/,
  # message: "must contain at least one uppercase letter, one lowercase letter, and one digit" }, if: :password_digest_changed?
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }, unless: -> { phone_number.present? }
  validates :password, presence: true, length: { minimum: 6 }, unless: -> { phone_number.present? }
  validates :phone_number, presence: true, uniqueness: true, if: -> { phone_number.present? }
  validates :full_phone_number, uniqueness: true, if: -> { full_phone_number.present? }
  validates :uid, uniqueness: { scope: :provider }, if: -> { provider.present? }
  validates :terms_and_condition, acceptance: { accept: true }, unless: -> { phone_number.present? }

  has_one :wishlist, dependent: :destroy
  has_one :cart, dependent: :destroy
  has_many :reviews

  before_validation :parse_full_phone_number, if: -> { full_phone_number.present? }
  after_create :create_wishlist
  after_create :create_cart

  def phone_verification_code_expired?
    return true if phone_verification_code_sent_at.nil?
    phone_verification_code_sent_at < 1.minutes.ago
  end

  def generate_password_token!
    payload = { user_id: self.id, exp: 24.hours.from_now.to_i }
    JWT.encode(payload, Rails.application.secrets.secret_key_base, 'HS256')
  end

  def self.decode_password_token(token)
    body = JWT.decode(token, Rails.application.secrets.secret_key_base, true, algorithm: 'HS256')[0]
    HashWithIndifferentAccess.new body
  rescue
    nil
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
