class ProductItemNotificationService
  def initialize(product_item)
    @product_item = product_item
  end

  def call
    send_notifications
  end

  private

  def send_notifications
    User.includes(:notification).where.not(email: nil).find_each do |user|
      if user.notification&.email
        ProductItemMailer.new_product_item_email(user, @product_item).deliver_now
      end
    end

    User.includes(:notification).where.not(full_phone_number: nil).find_each do |user|
      if user.notification&.sms
        ::ProductItemSmsNotificationService.new(@product_item).call
      end
    end
  end
end
