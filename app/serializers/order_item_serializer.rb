class OrderItemSerializer < ActiveModel::Serializer
  attributes :id, :product_item_id, :order_id, :product_item_variant_id, :quantity, :total_price, :created_at, :contact_number, :order_placed, :product_name, :user_name, :address

  def order_placed
    object.created_at
  end

  def product_name
    ProductItem.find_by(id: object.product_item_id).name
  end

  def user_name
    Address.find_by(id: object.order.address_id).first_name
  end

  def contact_number
    Address.find_by(id: object.order.address_id).phone_number
  end

  def address
    Address.find_by(id: object.order.address_id)
  end

end
