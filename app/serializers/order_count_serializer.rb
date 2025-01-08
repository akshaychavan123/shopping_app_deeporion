class OrderCountSerializer < ActiveModel::Serializer
  attributes :total_orders, :pending_orders, :delivered_orders, :cancelled_orders, :categories, :product

  def total_orders
    scope.count
  end

  def pending_orders
    scope.joins(:order_items).where(order_items: { status: 'pending' }).distinct.count
  end

  def delivered_orders
    scope.joins(:order_items).where(order_items: { status: 'delivered' }).distinct.count
  end

  def cancelled_orders
    scope.joins(:order_items).where(order_items: { status: 'cancelled' }).distinct.count
  end

  def categories
    Category.joins(subcategories: { products: { product_items: :order_items } })
            .where(order_items: { order_id: scope.select(:id) })
            .distinct.count
  end

  def product
    Product.joins(product_items: :order_items)
           .where(order_items: { order_id: scope.select(:id) })
           .distinct.count
  end
  
  private

  def scope
    if instance_options[:params][:start_date].present? && instance_options[:params][:end_date].present?
      Order.where(created_at: instance_options[:params][:start_date]..instance_options[:params][:end_date])
    else
      Order.all
    end
  end
end