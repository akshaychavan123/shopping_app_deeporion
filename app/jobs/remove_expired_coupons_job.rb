class RemoveExpiredCouponsJob < ApplicationJob
  queue_as :default

  def perform
    expired_coupons = Coupon.where("end_date <= ?", Time.current)
    expired_coupons.find_each do |coupon|
      Rails.logger.info "Processing expired coupon: #{coupon.id}"
      Product.where(id: coupon.product_ids).find_each do |product|
        product.product_items.find_each do |product_item|
          product_item.product_item_variants.find_each do |variant|
            remove_coupon_discount_from_variant(variant)
          end
        end
      end
    end
  end

  private

  def remove_coupon_discount_from_variant(variant)
    Rails.logger.info "Removing discount from variant: #{variant.id}"
    
    if variant.update(
      discount_percent: nil,
      discounted_price: variant.price
    )
      Rails.logger.info "Successfully removed discount from variant: #{variant.id}"
    else
      Rails.logger.error "Failed to remove discount from variant: #{variant.id}, Errors: #{variant.errors.full_messages}"
    end
  end
end
