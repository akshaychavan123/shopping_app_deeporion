class Api::V1::OrderItemsController < ApplicationController
    before_action :authorize_request

    def index
        order_items = OrderItem.all
        render json: {
      orders: ActiveModelSerializers::SerializableResource.new(order_items, each_serializer: OrderItemSerializer)
    }
    end

    def pending_orders
      if params[:status] == "pending"
        order_items = OrderItem.where(status: "pending")
      else
        order_items = OrderItem.where(status: "delivered")
      end      
      render json: {
        orders: ActiveModelSerializers::SerializableResource.new(order_items, each_serializer: OrderItemSerializer)
      }        
    end

    def order_count    
      order_details=Order.new
      render json: {
        orders: ActiveModelSerializers::SerializableResource.new(order_details,each_serializer: OrderCountSerializer)
      }        
    end

    def order_status_graph   
      order_details = Order.joins(:order_items).select("DATE(orders.created_at) AS order_date,COUNT(CASE WHEN order_items.status = 'pending' THEN 1 END) AS pending_count,COUNT(CASE WHEN order_items.status =
      'delivered' THEN 1 END) AS delivered_count").where("orders.created_at >= ?", 1.week.ago).group("DATE(orders.created_at)")
      pending_orders = order_details.sum { |order| order.pending_count.to_i }
      delivered_orders = order_details.sum { |order| order.delivered_count.to_i }
      total_orders = pending_orders + delivered_orders
      if order_details.present?
        render json: { order_details: order_details, pending_orders: pending_orders, delivered_orders: delivered_orders, total_orders: total_orders}, status: :ok 
      else
        render json: { order_details: [] }, status: :not_found 
      end    
    end

    def revenue_graph   
      data = Order.joins(:order_items).where("orders.created_at <= ?", 1.week.ago).group("DATE(orders.created_at)").select("DATE(orders.created_at) as order_date, COUNT(order_items.id) as item_count,SUM(
        order_items.total_price) as total_price ,COUNT(orders.id) as order_count")
      if data.present?
        render json: { data: data}, status: :ok 
      else
        render json: { data: [] }, status: :not_found 
      end    
    end

end
