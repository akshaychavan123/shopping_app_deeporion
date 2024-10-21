class OrderNotificationService
  def initialize(order)
    @order = order
    @user = order.user
  end

  def call
		if @user.notification&.email
			OrderMailer.order_confirmation(@order).deliver_now
		end

		# Uncomment this if you plan to add SMS notification support
		# if @user.notification&.sms
		#   ::OrderSmsNotificationService.new(@order).call
		# end
  end
end
