class OrderNotificationService
  def initialize(order)
    @order = order
    @user = order.user
  end
  
  def call
    send_email_notification if @user.notification&.email && @user.email.present?
    send_sms_notification if @user.notification&.sms && @user.full_phone_number&.present?
  end

  private

  def send_email_notification
    OrderMailer.order_confirmation(@order).deliver_now
  end

  def send_sms_notification
    ::OrderSmsNotificationService.new(@order, @user.full_phone_number).call
  end
end
