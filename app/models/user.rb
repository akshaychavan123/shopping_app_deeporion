class User < ApplicationRecord
	has_secure_password
	validates :email, presence: true, uniqueness: true
	validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
	validates :password,
						length: { minimum: 6 },
						if: -> { new_record? || !password.nil? }

	has_one :wishlist, dependent: :destroy
	after_create :create_wishlist

	private

	def create_wishlist
		Wishlist.create(user: self)
	end

end


