class Api::V1::CartsController < ApplicationController
  before_action :authorize_request
  before_action :set_cart, only: [:show, :discount_on_amount_coupons, :apply_coupon]

  def show
    @cart_items = @cart.cart_items.includes(:product_item, :product_item_variant).order(:created_at)
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

  def discount_on_amount_coupons
    if params[:coupon_code].present?
      @coupons = Coupon.where("promo_type = ? AND promo_code ILIKE ?", 'discount_on_amount', "%#{params[:coupon_code]}%")
    else
      @coupons = Coupon.where(promo_type: 'discount_on_amount')
    end
  
    subtotal = @cart.cart_items.sum { |item| item.product_item_variant.price * item.quantity }
  
    render json: {
      data: ActiveModelSerializers::SerializableResource.new(@coupons, each_serializer: CouponForCartSerializer, subtotal: subtotal, current_user: @current_user)
    }, status: :ok
  end

  def apply_coupon
    coupon = Coupon.find_by(promo_code: params[:promo_code])
  
    if coupon.present?
      if coupon_valid?(coupon)
        apply_coupon_to_cart(coupon)
  
        if @discount > @subtotal
          return render json: { error: 'Discount exceeds subtotal, coupon cannot be applied' }, status: :unprocessable_entity
        end

        if coupon.max_purchase.present? && @subtotal < coupon.max_purchase.to_f
          return render json: { error: "Minimum purchase of #{coupon.max_purchase} required to apply this coupon" }, status: :unprocessable_entity
        end
  
        @subtotal -= @discount
        @subtotal = [@subtotal, 0].max
  
        @taxes = @cart.cart_items.sum { |item| calculate_gst(item.product_item_variant.discounted_price) * item.quantity }
        @total = @subtotal + @taxes + @delivery_charge
  
        # Track coupon usage
        CouponUsage.create(user_id: @current_user.id, coupon_id: coupon.id)
  
        render json: {
          message: 'Coupon applied successfully',
          order_summary: {
            subtotal: @subtotal + @discount,
            discount: @discount,
            taxes: @taxes,
            delivery_charge: @delivery_charge,
            total: @total
          }
        }, status: :ok
      else
        render json: { error: 'Coupon is invalid or expired' }, status: :unprocessable_entity
      end
    else
      render json: { error: [] }, status: :ok
    end
  end

  private

  def coupon_valid?(coupon)
    return false if coupon.start_date > Date.today
    return false if coupon.max_purchase.blank?
    
    total_uses = CouponUsage.where(coupon_id: coupon.id).count
    return false if coupon.max_uses_per_promo && total_uses >= coupon.max_uses_per_promo

    user_uses = CouponUsage.where(coupon_id: coupon.id, user_id: @current_user.id).count
    return false if coupon.max_uses_per_client && user_uses >= coupon.max_uses_per_client

    true
  end
  
  def apply_coupon_to_cart(coupon)
    calculate_order_summary
    @discount = 0.0
  
    # Check if it's a product-level or amount-level coupon
    if coupon.promo_type == 'discount_on_product'
      apply_product_level_discount(coupon)
    elsif coupon.promo_type == 'discount_on_amount'
      apply_amount_level_discount(coupon)
    end
  end

  # Apply product-level discount
  def apply_product_level_discount(coupon)
    @cart.cart_items.each do |item|
      if coupon.product_ids.include?(item.product_item.id)
        # Calculate product-level discount
        if coupon.discount_type == 'percentage'
          @discount += (item.product_item_variant.price * (coupon.amount_off / 100.0)) * item.quantity
        elsif coupon.discount_type == 'amount'
          @discount += coupon.amount_off * item.quantity
        end
      end
    end
  end

  # Apply amount-level discount
  def apply_amount_level_discount(coupon)
    if @subtotal >= coupon.max_purchase.to_f
      if coupon.discount_type == 'percentage'
        @discount = @subtotal * (coupon.amount_off / 100.0)
      elsif coupon.discount_type == 'amount'
        @discount = coupon.amount_off
      end
    end
  end
  
  def set_cart
    @cart = Cart.find_or_create_by(user: @current_user)
  end

  def calculate_order_summary
    @subtotal = @cart.cart_items.sum { |item| item.product_item_variant.discounted_price * item.quantity }
    @taxes = (@cart_items || []).sum { |item| calculate_gst(item.product_item_variant.discounted_price) * item.quantity }
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
