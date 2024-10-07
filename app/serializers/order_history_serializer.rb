class OrderHistorySerializer < ActiveModel::Serializer
  attributes :id, :total_price, :address_id, :payment_status, :created_at, :order_number

  has_many :order_items, serializer: OrderItemSerializer

  def created_at
    object.created_at.strftime('%B %d, %Y %H:%M')
  end
end