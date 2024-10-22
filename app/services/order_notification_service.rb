class OrderNotificationService
  def initialize(order)
    @order = order
    @user = order.user
  end

  def call
    if @user.notification&.email
      OrderMailer.order_confirmation(@order).deliver_now
    end
  end
end
