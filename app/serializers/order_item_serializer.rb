class OrderItemSerializer < ActiveModel::Serializer
  attributes :id, :product_item_id, :order_id, :product_item_variant_id, :quantity, :total_price, :status, :created_at, :contact_number, :order_placed, :product_image, :product_name, :user_name, :address

  def order_placed
    object.created_at
  end

  def product_name
    @productitem = ProductItem.find_by(id: object.product_item_id)
    @productitem.name if @productitem.present?
  end

  def user_name
    @addressdetail = Address.find_by(id: object.order.address_id)
    @addressdetail.first_name if @addressdetail.present?
  end

  def contact_number
    @addressdetail = Address.find_by(id: object.order.address_id)
    @addressdetail.phone_number if @addressdetail.present?
  end

  def address
    Address.find_by(id: object.order.address_id)
  end

  def product_image
    host = base_url
    @productitem = ProductItem.find_by(id: object.product_item_id)
    if @productitem.image.attached?
      if Rails.env.development? || Rails.env.test?
        host + Rails.application.routes.url_helpers.rails_blob_path(@productitem.image, only_path: true)
      else
        @productitem.image.service.send(:object_for, @productitem.image.key).public_url
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
