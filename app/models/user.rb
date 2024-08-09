class User < ApplicationRecord
  has_secure_password
  before_validation :downcase_email

  validates :password, format: { with: /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}\z/,
  message: "must contain at least one uppercase letter, one lowercase letter, and one digit" }, if: :password_digest_changed?
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }, unless: -> { phone_number.present? }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  # validates :password, presence: true, length: { minimum: 6 }, unless: -> { phone_number.present? } 
  # validates :phone_number, presence: true, uniqueness: true, if: -> { phone_number.present? }
  # validates :full_phone_number, uniqueness: true, if: -> { full_phone_number.present? }
  validates :uid, uniqueness: { scope: :provider }, if: -> { provider.present? }
  validates :terms_and_condition, acceptance: { accept: true }, unless: -> { phone_number.present? }

  has_one :wishlist, dependent: :destroy
  has_one :cart, dependent: :destroy
  has_many :reviews
  has_many :review_votes
  has_one_attached :image
  has_one :address, dependent: :destroy
  has_one :card_detail, dependent: :destroy

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

  def self.create_user_for_google(data)
    where(uid: data["email"]).first_or_initialize.tap do |user|
      user.provider="google_oauth2"
      user.uid=data["email"]
      user.email=data["email"]
      user.password=generate_secure_password
      user.password_confirmation=user.password
      user.save!
    end
  end  

  def self.generate_secure_password
    length = 8
    chars = [
      ('a'..'z').to_a,
      ('A'..'Z').to_a,
      ('0'..'9').to_a,
      %w[! @ # $ % ^ & *]
    ].flatten
    password = [
      ('a'..'z').to_a.sample,
      ('A'..'Z').to_a.sample,
      ('0'..'9').to_a.sample,
      %w[! @ # $ % ^ & *].sample
    ]

    (length - password.size).times do
      password << chars.sample
    end

    password.shuffle.join
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

  def downcase_email
    self.email = email.downcase if email.present?
  end
end
