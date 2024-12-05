class Api::V2::PaymentsController < ApplicationController
  # before_action :authorize_request

  def create_order
    plan_id = params[:plan_id]
    plan = Plan.find_by(id: plan_id)
  
    if plan.nil?
      render json: { error: 'Plan not found' }, status: :not_found
      return
    end
  
    amount = plan.amount  # Razorpay expects the amount in paise (1 INR = 100 paise)
  
    razorpay_order = Razorpay::Order.create(
      amount: amount,
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
  
    # Ensure the amount is provided in paise (1 INR = 100 paise)
    amount_in_paise = (amount.to_f * 100).to_i
  
    begin
      # Fetch the payment to verify existence
      razorpay_payment = Razorpay::Payment.fetch(payment_id)
  
      # Check payment status before capturing
      if razorpay_payment.status == 'authorized'
        # Capture the payment
        captured_payment = razorpay_payment.capture(amount: amount_in_paise)
  
        # Now use `new` to save the payment in the database
        payment = Payment.new(
          payment_id: razorpay_payment.id,
          status: captured_payment.status,
          amount: captured_payment.amount / 100.0, # Convert back to INR
          currency: captured_payment.currency,
          captured_amount: captured_payment.amount / 100.0, # Convert back to INR
        )
  
        if payment.save
          render json: {
            success: true,
            message: 'Payment captured successfully and saved',
            captured_payment: captured_payment
          }, status: :ok
        else
          render json: { error: 'Failed to save payment details' }, status: :unprocessable_entity
        end
      else
        render json: {
          success: false,
          message: 'Payment cannot be captured. Status: ' + razorpay_payment.status
        }, status: :unprocessable_entity
      end
    rescue Razorpay::Error => e
      render json: { success: false, error: e.message }, status: :unprocessable_entity
    end
  end

  def verify_payment
    payment_id = params[:payment_id]
    order_id = params[:order_id]
    signature = params[:signature]

    razorpay_payment = Razorpay::Payment.fetch(payment_id)
    debugger
    if Razorpay::Utility.verify_payment_signature(
      payment_id: payment_id,
      order_id: order_id,
      signature: signature
    )
      create_subscription(razorpay_payment)
      render json: { success: true, message: 'Payment verified and subscription created.' }
    else
      render json: { success: false, message: 'Payment verification failed.' }, status: :unprocessable_entity
    end
  end

  # def checkout_iframe
  #   plan_id = params[:plan_id]
  #   plan = Plan.find_by(id: plan_id)

  #   if plan.nil?
  #     render json: { error: 'Plan not found' }, status: :not_found
  #     return
  #   end

  #   # Razorpay expects amount in paise (1 INR = 100 paise)
  #   amount = plan.amount * 100
  #   razorpay_order = Razorpay::Order.create(
  #     amount: amount,
  #     currency: 'INR',
  #     receipt: "receipt_#{SecureRandom.hex(8)}",
  #     payment_capture: 0  # Automatically capture payment after success
  #   )

  #   @razorpay_order_id = razorpay_order.id
  #   @amount = plan.amount
  #   @currency = 'INR'
  #   @razorpay_key = ENV['RAZORPAY_KEY_ID']
  #   @callback_url = payment_verification_url

  #   render layout: false, inline: <<-HTML
  #     <!DOCTYPE html>
  #     <html lang="en">
  #     <head>
  #       <meta charset="UTF-8">
  #       <meta name="viewport" content="width=device-width, initial-scale=1.0">
  #       <title>Razorpay Payment</title>
  #     </head>
  #     <body>
  #       <button id="rzp-button">Pay Now</button>
  #       <script src="https://checkout.razorpay.com/v1/checkout.js"></script>
  #       <script>
  #         var options = {
  #           "key": "#{@razorpay_key}", // Razorpay Key
  #           "amount": "#{@amount * 100}", // Amount in paise
  #           "currency": "#{@currency}",
  #           "order_id": "#{@razorpay_order_id}", // Razorpay Order ID
  #           "name": "Your Company Name",
  #           "description": "Plan #{@plan_id}",
  #           "image": "https://your-logo-url.com/logo.png",
  #           "handler": function (response) {
  #             // response contains payment_id, which is what you need
  #             var paymentId = response.razorpay_payment_id; 
  #             // Payment success handler
  #             fetch("#{@callback_url}", {
  #               method: "POST",
  #               headers: {
  #                 "Content-Type": "application/json"
  #               },
  #               body: JSON.stringify({
  #                 razorpay_payment_id: response.razorpay_payment_id,
  #                 razorpay_order_id: response.razorpay_order_id,
  #                 razorpay_signature: response.razorpay_signature
  #               })
  #             }).then(res => res.json())
  #               .then(data => alert(data.message || "Payment success!"));
  #           },
  #           "prefill": {
  #             "name": "Test User",
  #             "email": "testuser@example.com"
  #           },
  #           "theme": {
  #             "color": "#F37254"
  #           }
  #         };
  #         var rzp1 = new Razorpay(options);
  #         document.getElementById('rzp-button').onclick = function(e) {
  #           console.log("Button clicked"); // Check if this prints
  #           rzp1.open();
  #           e.preventDefault();
  #         }
  #       </script>
  #     </body>
  #     </html>
  #   HTML
  # end 

  private

  def payment_verification_url
    "http://localhost:3000/api/v2/payments/verify_payment"
  end
  
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
end
