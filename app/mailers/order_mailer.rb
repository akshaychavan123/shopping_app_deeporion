class OrderMailer < ApplicationMailer
  default from: 'notifications@yourapp.com'

  def order_confirmation(order)
    @order = order
    @user = order.user
    @address = order.address
    mail(to: @address.email, subject: 'Order Confirmation')
  end
end
