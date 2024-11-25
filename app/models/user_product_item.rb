class UserProductItem < ApplicationRecord
  belongs_to :user
  belongs_to :product_item

  validates :user_id, uniqueness: { scope: :product_item_id, message: 'already viewed this product item' }
end
