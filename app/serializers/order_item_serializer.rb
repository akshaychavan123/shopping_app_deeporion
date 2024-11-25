class OrderItemSerializer < ActiveModel::Serializer
  attributes :id, :product_item_id, :order_id, :product_item_variant_id, :product_item_image, :quantity, :total_price, :status, :return_status, :created_at, :contact_number, :order_placed, :product_name, :product_descritpion, :estimated_delivery, :user_name

  def order_placed
    object.created_at
  end

  def product_name
    @productitem = ProductItem.find_by(id: object.product_item_id)
    @productitem.name if @productitem.present?
  end

  def product_descritpion
    @productitem = ProductItem.find_by(id: object.product_item_id)
    @productitem.description if @productitem.present?
  end

  def estimated_delivery
    if object.created_at.present?
      estimated_date = object.created_at + 7.days
      estimated_date.strftime("%-d %B %Y")
    end
  end

  def product_item_image
    @productitem = ProductItem.find_by(id: object.product_item_id)
    
    if @productitem.nil?
      return nil
    end
  
    if @productitem.image.attached?
      host = base_url
      Rails.env.development? || Rails.env.test? ?
        "#{host}#{Rails.application.routes.url_helpers.rails_blob_path(@productitem.image, only_path: true)}" :
        @productitem.image.service.send(:object_for, @productitem.image.key).public_url
    else
      nil
    end
  end

  def user_name
    @addressdetail = Address.find_by(id: object.order.address_id)
    @addressdetail.first_name if @addressdetail.present?
  end

  def contact_number
    @addressdetail = Address.find_by(id: object.order.address_id)
    @addressdetail.phone_number if @addressdetail.present?
  end

  private

  def base_url
    ENV['BASE_URL'] || 'http://localhost:3000'
  end 
end
