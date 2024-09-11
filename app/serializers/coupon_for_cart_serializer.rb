class CouponForCartSerializer < ActiveModel::Serializer
  attributes  :id, :promo_code_name, :promo_code, :save,  :start_date, :end_date, :promo_type, :amount_off,
              :max_uses_per_client, :max_uses_per_promo, :image

  
  def save
    subtotal = @instance_options[:subtotal] || 0
    if object.promo_type == 'discount on amount' && subtotal > 0
      discount = (subtotal * (object.amount_off / 100.0)).round(2)
      discount > subtotal ? subtotal : discount
    else
      0
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
end
