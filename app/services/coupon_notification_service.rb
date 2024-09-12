class CouponNotificationService
  def initialize(coupon)
    @coupon = coupon
  end

  def call
    send_email_and_sms_notifications
  end

  private

  def send_email_and_sms_notifications
    User.includes(:notification).where.not(email: nil).find_each do |user|
      if user.notification&.email
        CouponMailer.new_coupon_email(user, @coupon).deliver_later
      end
    end
    # if user.notification&.sms
    #   # ::CouponSmsNotificationService.new(@coupon).call
    # end
  end
end
