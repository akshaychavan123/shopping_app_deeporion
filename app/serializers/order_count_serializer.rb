class OrderCountSerializer < ActiveModel::Serializer
    attributes :total_orders, :pending_orders, :delivered_orders, :cancelled_orders, :categories, :product
  
    def total_orders
      Order.all.count
    end
  
    def pending_orders
      Order.joins(:order_items).where(order_items: { status: 'pending' }).distinct.count
    end
  
    def delivered_orders
      Order.joins(:order_items).where(order_items: { status: 'delivered' }).distinct.count
    end
  
    def cancelled_orders
      Order.joins(:order_items).where(order_items: { status: 'cancelled' }).distinct.count
    end
  
    def categories
      Category.all.count
    end

    def product
      Product.all.count
    end
  
end
  