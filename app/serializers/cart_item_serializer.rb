class CartItemSerializer < ActiveModel::Serializer
  attributes :id, :quantity, :size, :total_price, :expected_delivery, :return_availablity
  belongs_to :product_item, serializer: ProductItem3Serializer

  def size
    object.product_item_variant&.size
  end

  def expected_delivery
    start_date = Date.today
    end_date = start_date + 7.days
    "Get it by #{end_date.strftime('%A, %B %d, %Y')}"
  end

  def return_availablity 
    start_date = Date.today
    end_date = start_date + 14.days
    days_remaining = (end_date - start_date).to_i
    "#{days_remaining} days return available"
  end
end
