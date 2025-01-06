class Api::V2::PaymentsController < ApplicationController
  # before_action :authorize_request

  def create_order
    plan_id = params[:plan_id]
    plan = Plan.find_by(id: plan_id)
  
    if plan.nil?
      render json: { error: 'Plan not found' }, status: :ok
      return
    end
  
    razorpay_order = Razorpay::Order.create(
      amount: plan.amount,
      currency: 'INR',
      receipt: "receipt_#{SecureRandom.hex(8)}",
      payment_capture: 0
    )
  
    order = Order.new(
      razorpay_order_id: razorpay_order.id,
      amount: razorpay_order.amount / 100.0, # Convert back to INR
      currency: razorpay_order.currency,
      receipt: razorpay_order.receipt,
      status: 'created', # You can set this to 'created' or another default value
    )
  
    if order.save
      render json: { razorpay_order_details: razorpay_order, success: true, message: 'Order Created and saved successfully' }
    else
      render json: { error: 'Failed to save order' }, status: :unprocessable_entity
    end
  rescue Razorpay::Error => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def capture_payment
    payment_id = params[:payment_id]
    amount = params[:amount]
  
    amount_in_paise = (amount.to_f * 100).to_i
  
    begin
      razorpay_payment = Razorpay::Payment.fetch(payment_id)
  
      if razorpay_payment.status == 'captured'
        render json: {
          success: true,
          message: 'Payment has already been captured.',
          payment: {
            id: razorpay_payment.id,
            status: razorpay_payment.status,
            amount: razorpay_payment.amount / 100.00,
            currency: razorpay_payment.currency
          }
        }, status: :ok
      elsif razorpay_payment.status == 'authorized'
        captured_payment = razorpay_payment.capture(amount: amount_in_paise)
  
        payment = Payment.new(
          payment_id: razorpay_payment.id,
          status: captured_payment.status,
          amount: captured_payment.amount / 100.00,
          currency: captured_payment.currency,
          captured_amount: captured_payment.amount / 100.00
        )
  
        if payment.save
          render json: {
            success: true,
            message: 'Payment captured successfully and saved.',
            captured_payment: captured_payment
          }, status: :ok
        else
          render json: { error: 'Failed to save payment details.' }, status: :unprocessable_entity
        end
      else
        render json: {
          success: false,
          message: "Payment cannot be captured. Current status: #{razorpay_payment.status}."
        }, status: :unprocessable_entity
      end
    rescue Razorpay::Error => e
      render json: { success: false, error: e.message }, status: :unprocessable_entity
    end
  end

  def verify_payment
    razorpay_order_id = params[:order_id]
    razorpay_payment_id = params[:payment_id]
    razorpay_signature = params[:signature]
  
    if razorpay_order_id.blank? || razorpay_payment_id.blank? || razorpay_signature.blank?
      render json: { success: false, message: 'Missing required parameters.' }, status: :unprocessable_entity
      return
    end
  
    payment_response = {
      razorpay_order_id: razorpay_order_id,
      razorpay_payment_id: razorpay_payment_id,
      razorpay_signature: razorpay_signature
    }
  
    begin
      Razorpay::Utility.verify_payment_signature(payment_response)
      render json: { success: true, message: 'Payment verified successfully.' }, status: :ok
    rescue Razorpay::SignatureVerificationError => e
      Rails.logger.error "Razorpay Signature Verification Failed: #{e.message}"
      render json: { success: false, message: 'Payment verification failed. Invalid signature.' }, status: :unprocessable_entity
    rescue StandardError => e
      Rails.logger.error "Unexpected error during payment verification: #{e.message}"
      render json: { success: false, message: 'An error occurred while verifying payment.' }, status: :internal_server_error
    end
  end 

  private
  
  def create_subscription(razorpay_payment)
    plan_id = razorpay_payment.notes[:plan_id]
    plan = Plan.find_by(id: plan_id)

    # Assuming you already have @current_user as the user making the payment
    subscription = Subscription.new(
      user: @current_user,
      plan: plan,
      razorpay_subscription_id: razorpay_payment.subscription_id,
      status: 'active',
      start_date: Time.now,
      end_date: Time.now + 1.month  # Example: subscription valid for 1 month
    )

    if subscription.save
      # Send confirmation email, or any other post-subscription tasks
      render json: { success: true, subscription: subscription, message: 'Subscription created successfully' }, status: :created
    else
      render json: { success: false, errors: subscription.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def payment_params
    params.require(:payment).permit(:plan_id, :amount, :payment_id, :order_id, :signature)
  end
end
