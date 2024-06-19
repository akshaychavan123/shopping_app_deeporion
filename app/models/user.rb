class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true, uniqueness: true, unless: -> { phone_number.present? }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, unless: -> { phone_number.present? }
  validates :password, presence: true, length: { minimum: 6 }, unless: -> { phone_number.present? }
  validates :phone_number, presence: true, uniqueness: true, if: -> { phone_number.present? }

  has_one :wishlist, dependent: :destroy
  has_one :cart, dependent: :destroy
  after_create :create_wishlist
  after_create :create_cart


  private

  def create_wishlist
    Wishlist.create(user: self)
  end
  
  def create_cart
    Cart.create(user: self)
  end  
end