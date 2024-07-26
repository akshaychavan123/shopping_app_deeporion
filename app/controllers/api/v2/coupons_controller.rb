class Api::V2::CouponsController < ApplicationController
  before_action :authorize_request
  before_action :check_user
  def index
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
  
  def show
    coupon = Coupon.find(params[:id])
    render json: coupon,status: :ok
  end

  def create
    @coupon = Coupon.new(coupon_params)
    @coupon.couponable_type = coupon_params[:couponable_type].camelize
    if @coupon.save
      if params[:image].present?
        @coupon.image.attach(params[:image])
      end
      render json: { data: ActiveModelSerializers::SerializableResource.new(@coupon, serializer: CouponSerializer) }, status: :created
    else
      render json: { errors: @coupon.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def coupon_params
    params.permit(:promo_code_name, :promo_code, :start_date, :end_date, :max_uses_per_client, :max_uses_per_promo, :promo_type, :amount_off, :couponable_id, :couponable_type, :image
    )
  end

  def check_user
    unless @current_user.type == "Admin"
      render json: { errors: ['Unauthorized access'] }, status: :forbidden
    end
  end
end