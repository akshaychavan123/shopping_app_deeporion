class Api::V1::OrderItemsController < ApplicationController
    before_action :authorize_request

    def index
        order_items = OrderItem.all
        render json: {
      orders: ActiveModelSerializers::SerializableResource.new(order_items, each_serializer: OrderItemSerializer)
    }
    end
end
