class Api::V1::OrderItemsController < ApplicationController
  before_action :authorize_request
  before_action :set_order_item, only: [:update, :destroy]

  def index
    if params[:status].present?
      statuses = params[:status].split(',')
      order_items = OrderItem.where(status: statuses).order(created_at: :desc)
    else
      order_items = OrderItem.order(created_at: :desc)
    end

    render json: {
      orders: ActiveModelSerializers::SerializableResource.new(order_items, each_serializer: OrderItemSerializer)
    }
  end
  
  def destroy
    @order_item = OrderItem.find(params[:id])
    @order_item.destroy
    render json: { message: 'Order Item deleted successfully' }, status: :ok
    rescue ActiveRecord::RecordNotDestroyed
    render json: { error: 'Failed to delete Order Item' }, status: :unprocessable_entity
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
    start_date = params[:start_date].present? ? Date.parse(params[:start_date]) : 1.week.ago.to_date
    end_date = params[:end_date].present? ? Date.parse(params[:end_date]) : Date.today
  
    order_details = Order.joins(:order_items)
                         .select(
                           "DATE(orders.created_at) AS order_date,
                            COUNT(CASE WHEN order_items.status = 'pending' THEN 1 END) AS pending_count,
                            COUNT(CASE WHEN order_items.status = 'delivered' THEN 1 END) AS delivered_count"
                         )
                         .where("DATE(orders.created_at) BETWEEN ? AND ?", start_date, end_date)
                         .group("DATE(orders.created_at)")
  
    pending_orders = order_details.sum { |order| order.pending_count.to_i }
    delivered_orders = order_details.sum { |order| order.delivered_count.to_i }
    total_orders = pending_orders + delivered_orders
  
    if order_details.present?
      render json: {
        order_details: order_details,
        pending_orders: pending_orders,
        delivered_orders: delivered_orders,
        total_orders: total_orders
      }, status: :ok
    else
      render json: { order_details: [] }, status: :not_found
    end
  end  

  def update
    if @order_item.update(order_item_params)
      render json: {
        order: ActiveModelSerializers::SerializableResource.new(@order_item, serializer: OrderItemSerializer),
        message: "Order item successfully updated"
      }, status: :ok
    else
      render json: {
        errors: @order_item.errors.full_messages
      }, status: :unprocessable_entity
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

  private

  def set_order_item
    @order_item = OrderItem.find_by(id: params[:id])
    render json: { message: "Order item not found" }, status: :ok if @order_item.nil?
  end

  def order_item_params
    params.permit(:status)
  end
end
