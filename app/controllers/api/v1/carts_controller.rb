class Api::V1::CartsController < ApplicationController
  before_action :authorize_request
  before_action :set_cart, only: [:show]

  # def show
  #   @cart_items = @cart.cart_items.includes(:product_item)
  #   render json: { data: ActiveModelSerializers::SerializableResource.new(@cart_items, each_serializer: CartItemSerializer) }
  # end

  def show
    @cart_items = @cart.cart_items.includes(:product_item)
    calculate_order_summary

    render json: {
      data: ActiveModelSerializers::SerializableResource.new(@cart_items, each_serializer: CartItemSerializer),
      order_summary: {
        subtotal: @subtotal,
        taxes: @taxes,
        delivery_charge: @delivery_charge,
        total: @total
      },
      cart_quantity: @cart_items.count
    }, status: :ok
  end

  def product_item_list_by_coupon
    coupon = Coupon.find(params[:id])
    
    case coupon.couponable
    when ProductItem
      @product_items = [coupon.couponable]
    when Product
      @product_items = coupon.couponable.product_items
    when Subcategory
      @product_items = ProductItem.joins(:product).where(products: { subcategory_id: coupon.couponable.id })
    when Category
      @product_items = ProductItem.joins(product: :subcategory).where(subcategories: { category_id: coupon.couponable.id })
    else
      @product_items = []
    end
    
    render json: {
      data: ActiveModelSerializers::SerializableResource.new(@product_items, each_serializer: ProductItem2Serializer, current_user: @current_user)    }, status: :ok
  end

  def coupon_list
    @coupons = Coupon.all

    @coupons.each do |coupon|
      if coupon.couponable.nil?
        Rails.logger.error "Nil couponable found for coupon ID #{coupon.id}!"
      else
        Rails.logger.info "Couponable for coupon ID #{coupon.id}: #{coupon.couponable.inspect}"
      end
    end

    render json: @coupons
  end

  private

  def set_cart
    @cart = Cart.find_or_create_by(user: @current_user)
  end

  def calculate_order_summary
    @subtotal = @cart.cart_items.sum { |item| item.product_item_variant.price * item.quantity }
    @taxes = @cart_items.sum { |item| calculate_gst(item.product_item_variant.price) * item.quantity }
    @delivery_charge = calculate_delivery_charge(@subtotal)
    @total = @subtotal + @taxes + @delivery_charge
  end

  def calculate_gst(price)
    if price <= 1000
      (price * 0.05).round(2)
    else
      (price * 0.12).round(2)
    end
  end

  def calculate_delivery_charge(subtotal)
    if subtotal < 499
      49.0
    else
      0.0
    end
  end
end
