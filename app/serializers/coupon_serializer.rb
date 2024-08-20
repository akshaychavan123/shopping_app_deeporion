class CouponSerializer < ActiveModel::Serializer
	attributes  :id, :promo_code_name, :promo_code, :start_date, :end_date, :promo_type, :amount_off,
							:max_uses_per_client, :max_uses_per_promo, :couponable_type, :couponable_id, :image

	# belongs_to :couponable, polymorphic: true
	def image
    object.image.attached? ? "#{base_url}#{Rails.application.routes.url_helpers.rails_blob_path(object.image, only_path: true)}" : nil
  end

  private

  def base_url
    ENV['BASE_URL'] || 'http://localhost:3000'
  end    
end
