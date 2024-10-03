class Api::V1::OrderItemsController < ApplicationController
  before_action :authorize_request
  before_action :set_order_item, only: [:update, :destroy]

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

  def destroy
    if @order_item.destroy
      render json: {
        message: "Order item successfully deleted"
      }, status: :ok
    else
      render json: {
        errors: @order_item.errors.full_messages
      }, status: :unprocessable_entity
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
