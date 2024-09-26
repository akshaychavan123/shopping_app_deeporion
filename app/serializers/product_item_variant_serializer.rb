class ProductItemVariantSerializer < ActiveModel::Serializer
  attributes :id, :price, :product_item_id, :size, :in_stock, :discounted_price, :discount_percent

  def discounted_price
    applicable_coupon = @instance_options[:applicable_coupon]
  
    if applicable_coupon
      discount_percentage = applicable_coupon.amount_off
      discount_amount = (object.price * discount_percentage / 100.0)  
      [object.price - discount_amount, 0].max
    else
      object.price
    end
  end
  

  def discount_percent
    applicable_coupon = @instance_options[:applicable_coupon]
    
    if applicable_coupon && object.price > 0
      discount_percentage = applicable_coupon.amount_off
      "#{discount_percentage}% off"
    else
      nil
    end
  end
end
