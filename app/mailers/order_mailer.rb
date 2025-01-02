class OrderMailer < ApplicationMailer

  def order_confirmation(order)
    @order = order
    @user = @order.user
    @address = @order.address
    mail(to: @user.email, subject: 'Order Confirmation')
  end
end
