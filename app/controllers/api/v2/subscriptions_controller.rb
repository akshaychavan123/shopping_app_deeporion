class Api::V2::SubscriptionsController < ApplicationController
  before_action :authorize_request
  before_action :set_plan, only: [:create]

  def create
    if @plan.nil?
      render json: { error: 'Plan not found' }, status: :ok
      return
    end

    total_count = params[:total_count] || 12
    quantity = params[:quantity] || 1
    start_at = params[:start_at] || Time.now.to_i
    expire_by = params[:expire_by] || (Time.now + 12.months).to_i

    # Create a Razorpay subscription
    razorpay_subscription = Razorpay::Subscription.create({
      plan_id: @plan.razorpay_plan_id,
      total_count: total_count,
      quantity: quantity,
      start_at: start_at,
      expire_by: expire_by,
      customer_notify: 1,
    })

    @subscription = Subscription.new(
      user: @current_user.id,
      plan: @plan,
      razorpay_subscription_id: razorpay_subscription.id,
      status: razorpay_subscription.status,
      start_date: Time.at(razorpay_subscription.start_at),
      end_date: Time.at(razorpay_subscription.end_at)
    )

    if @subscription.save
      render json: { success: true, subscription: @subscription, message: 'Subscription created successfully' }, status: :created
    else
      render json: { success: false, errors: @subscription.errors.full_messages }, status: :unprocessable_entity
    end
  rescue Razorpay::Error => e
    render json: { success: false, error: e.message }, status: :unprocessable_entity
  end

  private

  def set_plan
    @plan = Plan.find_by(id: params[:plan_id])
  end
end
