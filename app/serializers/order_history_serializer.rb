class OrderHistorySerializer < ActiveModel::Serializer
  attributes :id, :total_price, :address_id, :payment_status, :status, :receipt_number, :created_at, :address

  has_many :order_items, serializer: OrderItemSerializer

  def address
    Address.find_by(id: object.address_id)
  end

  def created_at
    object.created_at.strftime('%B %d, %Y %H:%M')
  end
end