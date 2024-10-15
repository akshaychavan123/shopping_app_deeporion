class Coupon < ApplicationRecord
  has_one_attached :image
  has_many :coupon_usages, dependent: :destroy
  
  validates :promo_code_name, :promo_code, presence: true
  validates :promo_code, uniqueness: true
  validates :start_date, :end_date, :promo_type, presence: true
  # validates :max_uses_per_client, :max_uses_per_promo, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validate :end_date_after_start_date
  enum promo_type: { discount_on_product: 'discount_on_product', discount_on_amount: 'discount_on_amount' }
  enum discount_type: { amount: 'amount', percentage: 'percentage' }

  after_save :apply_discount_to_variants, if: -> { promo_type == "discount_on_product" && product_ids.present? }
  after_destroy :revert_discount_on_variants

  private

  def apply_discount_to_variants
    return unless product_ids.present?
    Product.where(id: product_ids).each do |product|
      product.product_items.each do |product_item|
        product_item.product_item_variants.each do |variant|
          apply_coupon_discount_to_variant(variant)
        end
      end
    end
  end

  def apply_coupon_discount_to_variant(variant)
    if self.amount?
      discounted_price = [variant.price - amount_off, 0].max
      discount_percent = 100.0 * (amount_off.to_f / variant.price)
    elsif self.percentage?
      discount_percent = amount_off
      discounted_price = [variant.price - (variant.price * (discount_percent / 100.0)), 0].max
    end

    discount_percent = discount_percent.round(2)
    variant.update(
      discount_percent: discount_percent,
      discounted_price: discounted_price
    )
  end

  def revert_discount_on_variants
    return unless product_ids.present?
    Product.where(id: product_ids).each do |product|
      product.product_items.each do |product_item|
        product_item.product_item_variants.each do |variant|
          revert_coupon_discount_for_variant(variant)
        end
      end
    end
  end

  def revert_coupon_discount_for_variant(variant)
    variant.update(
      discount_percent: 0, 
      discounted_price: variant.price
    )
  end

  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?

    if end_date < start_date
      errors.add(:end_date, "must be after the start date")
    end
  end

  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?

    if end_date < start_date
      errors.add(:end_date, "must be after the start date")
    end
  end
end
