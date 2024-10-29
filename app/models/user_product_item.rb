class UserProductItem < ApplicationRecord
  belongs_to :user
  belongs_to :product_item_variant
end
