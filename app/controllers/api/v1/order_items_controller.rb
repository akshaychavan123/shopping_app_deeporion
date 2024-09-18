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


end
