class OrderItem < ApplicationRecord
  belongs_to :order
  # belongs_to :product_item

  # before_save :set_sub_total

  # private

  # def set_sub_total
  #   self.sub_total = product_item.price * quantity
  # end
end
