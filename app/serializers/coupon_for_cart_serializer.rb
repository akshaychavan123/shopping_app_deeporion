class CouponForCartSerializer < ActiveModel::Serializer
  attributes  :id, :promo_code_name, :promo_code, :save,  :start_date, :end_date, :promo_type, :amount_off,  :discount_type, :max_purchase,
              :max_uses_per_client, :max_uses_per_promo, :image

  def save
    subtotal = @instance_options[:subtotal] || 0

    if coupon_valid?(object, subtotal) && subtotal > 0
      
      if object.discount_on_amount?
        if object.percentage?
          discount = (subtotal * (object.amount_off / 100.0)).round(2)
        elsif object.amount?
          discount = object.amount_off.to_f
        else
          discount = 0.0
        end
        discount > subtotal ? subtotal : discount
      else
        0.0
      end
    else
      0.0
    end
  end

  def image
    host = base_url
    if object.image.attached?
      if Rails.env.development? || Rails.env.test?
        host + Rails.application.routes.url_helpers.rails_blob_path(object.image, only_path: true)
      else
        object.image.service.send(:object_for, object.image.key).public_url
      end
    else
      nil
    end
  end

  private

  def base_url
    ENV['BASE_URL'] || 'http://localhost:3000'
  end    

  def coupon_valid?(coupon, subtotal)
    return false if coupon.start_date > Date.today 
    return false if coupon.max_purchase.blank? || subtotal < coupon.max_purchase.to_f
    
    total_uses = CouponUsage.where(coupon_id: coupon.id).count
    return false if coupon.max_uses_per_promo && total_uses >= coupon.max_uses_per_promo

    user_uses = CouponUsage.where(coupon_id: coupon.id, user_id: @instance_options[:current_user].id).count
    return false if coupon.max_uses_per_client && user_uses >= coupon.max_uses_per_client

    true
  end
end
