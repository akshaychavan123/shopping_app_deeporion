class ProductItemSerializer < BaseSerializer
  attributes :id, :name, :brand, :price, :discounted_price, :description, :size, :material, :care, :product_code, :product_id
  
  attribute :images do |object|
    if object.images.attached?
      object.images.map do |image|
        "#{base_url}#{Rails.application.routes.url_helpers.rails_blob_path(image, only_path: true)}"
      end
    else
      []
    end
  end

  private

  def base_url
    BaseSerializer.base_url
  end
end
