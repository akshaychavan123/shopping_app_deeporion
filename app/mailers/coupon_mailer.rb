class CouponMailer < ApplicationMailer
  def new_coupon_email(user, coupon)
    @user = user
    @coupon = coupon
    mail(to: @user.email, subject: "New Coupon: #{coupon.promo_code_name}")
  end
end

