class ProductItemMailer < ApplicationMailer
  default from: 'no-reply@example.com'

  def new_product_item_email(user, product_item)
    @user = user
    @product_item = product_item
    mail(to: @user.email, subject: 'New Product Item Available')
  end
end
