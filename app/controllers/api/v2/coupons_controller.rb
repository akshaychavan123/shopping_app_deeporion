class Api::V2::CouponsController < ApplicationController
  before_action :authorize_request, only: [:create, :update, :destroy]
  before_action :set_coupon, only: [:show, :update, :destroy]
  before_action :check_user, only: [:create, :update, :destroy]

  def index
    @coupons = Coupon.all
    render json: { data: ActiveModelSerializers::SerializableResource.new(@coupons, each_serializer: CouponSerializer) }
  end  
  
  def show
    render json: { data: ActiveModelSerializers::SerializableResource.new(@coupon, serializer: CouponSerializer) }, status: :ok
  end

  def create
    if params[:product_ids].is_a?(String)
      params[:product_ids] = params[:product_ids].split(',').map(&:to_i)
    end
    
    @coupon = Coupon.new(coupon_params)

    if @coupon.promo_type == "discount_on_product" && coupon_params[:product_ids].blank?
      return render json: { errors: ["Product IDs must be present for 'discount_on_product' promo type"] }, status: :unprocessable_entity
    end
    
    @coupon.end_date = nil if coupon_params[:end_date] == "never"

    if @coupon.save
      attach_image
      render json: { data: ActiveModelSerializers::SerializableResource.new(@coupon, serializer: CouponSerializer) }, status: :created
      call_notification_service
    else
      render json: { errors: @coupon.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @coupon.update(coupon_params)
      attach_image
      render json: { data: ActiveModelSerializers::SerializableResource.new(@coupon, serializer: CouponSerializer) }, status: :ok
    else
      render json: { errors: @coupon.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @coupon.destroy
      render json: { message: 'Coupon successfully deleted' }, status: :ok
    else
      render json: { errors: ['Failed to delete coupon'] }, status: :unprocessable_entity
    end
  end

  def product_list
    render json: {
      data: ActiveModelSerializers::SerializableResource.new(@coupon.product_items, each_serializer: ProductItem2Serializer, current_user: @current_user)
    }, status: :ok
  end

  private

  def call_notification_service
    # ::CouponNotificationService.new(@coupon).call #SMS Notifications paused for now
    ::FcmNotificationService.new(@coupon).call
  end

  def set_coupon
    @coupon = Coupon.find_by(id: params[:id])
    render json: { errors: ['Coupon not found'] }, status: :not_found unless @coupon
  end

  def coupon_params
    params.permit(
      :promo_code_name, :promo_code, :start_date, :end_date, 
      :max_uses_per_client, :max_uses_per_promo, :promo_type, :discount_type, :max_purchase,
      :amount_off, product_ids: []
    )
  end

  def check_user
    unless @current_user.type == "Admin"
      render json: { errors: ['Unauthorized access'] }, status: :forbidden
    end
  end

  def attach_image
    if params[:image].present?
      @coupon.image.attach(params[:image])
    end
  end
end
