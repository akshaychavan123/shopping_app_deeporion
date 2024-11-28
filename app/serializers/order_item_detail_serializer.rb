class OrderItemDetailSerializer < ActiveModel::Serializer
    attributes :id, :product_item_image, :status, :product_name, :variant_details, :quantity, :total_price, :delivery_status,
               :delivery_address, :shipping_method, :tracking_id, :current_location, :kms_left, :last_stop,
               :exchange_available, :return_available
  
    def product_item_image
      product_item = object.product_item
    
      return nil unless product_item.image.attached?
    
      host = base_url
      if Rails.env.development? || Rails.env.test?
        Rails.application.routes.url_helpers.rails_blob_path(product_item.image, only_path: true, host: host)
      else
        productitem.image.service.send(:object_for, productitem.image.key).public_url
      end
    end   

    def product_name
      object.product_item.name
    end
  
    def variant_details
      {
        color: object.product_item&.color,
        size: object.product_item_variant.size
      }
    end
  
    def delivery_address
      address = object.order.address
      return unless address
  
      {
        name: "#{address.first_name} #{address.last_name}",
        phone: address.phone_number,
        full_address: "#{address.address}, #{address.city}, #{address.state} - #{address.pincode}"
      }
    end
  
    def shipping_method
      # "Logistics company: #{object.order.shipping_method}"
    end
  
    def tracking_id
      # object.order.tracking_id
    end
  
    def current_location
      # object.order.current_location
    end
  
    def kms_left
      # object.order.kms_left
    end
  
    def last_stop
      # object.order.last_stop
    end
  
    def delivery_status
      object.status
    end
  
    def exchange_available
      object.return_status == 'not_returned'
    end
  
    def return_available
      object.return_status == 'not_returned'
    end

    private

    def base_url
      ENV['BASE_URL'] || 'http://localhost:3000'
    end 
  end
  