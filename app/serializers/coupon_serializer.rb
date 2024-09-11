class CouponSerializer < ActiveModel::Serializer
	attributes  :id, :promo_code_name, :promo_code, :start_date, :end_date, :promo_type, :amount_off,
							:max_uses_per_client, :max_uses_per_promo, :product_ids, :image

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
