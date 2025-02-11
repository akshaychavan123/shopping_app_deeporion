class User < ApplicationRecord
  has_secure_password
  before_validation :downcase_email, unless: -> { phone_number.present? }
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP, message: "must be a valid email address" }, uniqueness: true, unless: -> { phone_number.present? }
  before_validation :normalize_gender

  validates :password, format: { with: /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}\z/,
  message: "must be at least 8 characters long, include at least one uppercase letter, one lowercase letter, and one number"}, if: :password_digest_changed?
  validates :email, presence: true, uniqueness: true, format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i }, unless: -> { phone_number.present? }
  validates :email, format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i }, unless: -> { phone_number.present? } 
  validates :uid, uniqueness: { scope: :provider }, if: -> { provider.present? }
  validates :terms_and_condition, acceptance: { accept: true }, unless: -> { phone_number.present? }
  validates :gender, presence: true, inclusion: { in: %w[male female other], message: "%{value} is not a valid gender" }, on: :update

  has_one :wishlist, dependent: :destroy
  has_one :cart, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :review_votes, dependent: :destroy
  has_one_attached :image
  has_many :addresses, dependent: :destroy
  has_one :card_detail, dependent: :destroy
  has_many :client_reviews, dependent: :destroy
  has_one :notification, dependent: :destroy
  has_many :devices, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :user_product_items, dependent: :destroy
  has_many :product_item_variants, through: :user_product_items
  has_many :user_notifications, dependent: :destroy
  has_many :client_review_comments, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :payments, dependent: :destroy

  before_validation :parse_full_phone_number, if: -> { full_phone_number.present? }
  after_create :create_wishlist
  after_create :create_cart
  after_create :create_notification

  def phone_verification_code_expired?
    return true if phone_verification_code_sent_at.nil?
    phone_verification_code_sent_at < 5.minutes.ago
  end

  def generate_password_token!
    payload = { user_id: self.id, exp: 24.hours.from_now.to_i }
    JWT.encode(payload, Rails.application.secrets.secret_key_base, 'HS256')
  end

  def self.decode_password_token(token)
    JsonWebToken.decode(token)
  end
  

  def self.create_user_for_google(data)
    where(uid: data["email"]).first_or_initialize.tap do |user|
      user.provider="google_oauth2"
      user.uid=data["email"]
      user.email=data["email"]
      user.name = data["name"]
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

  def self.ransackable_attributes(auth_object = nil)
    %w[name  email ]
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

  def create_notification
    Notification.create(
      user: self,
      app: true,    
      email: false, 
      sms: phone_number.present?,
      whatsapp: phone_number.present?  
    )
  end

  def normalize_gender
    self.gender = gender.to_s.downcase.strip if gender.present?
  end
end
