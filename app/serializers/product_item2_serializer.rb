class ProductItem2Serializer < ActiveModel::Serializer
    attributes :id, :category_id, :category_name,  :product_id, :name, :brand, :color, :price_of_first_variant, :discounted_price_of_first_variant, :discount_percent_of_first_variant, :is_favorite, :image, :rating_and_review, :in_stock

    def category_id
      object.product&.category_id
    end

    def category_name
      object.product&.category&.name
    end

    def image
      if object.image.attached?
        host = base_url
        Rails.env.development? || Rails.env.test? ?
          "#{host}#{Rails.application.routes.url_helpers.rails_blob_path(object.image, only_path: true)}" :
          object.image.service.send(:object_for, object.image.key).public_url
      end
    end  

    def rating_and_review
      reviews = Review.where(product_item_id: object.id)
      {
        total_review_count: reviews.count,
        average_rating: reviews.average(:star).to_f,
      }    
    end

    def price_of_first_variant
      object.product_item_variants&.first&.price
    end

    def discounted_price_of_first_variant
      object.product_item_variants&.first&.discounted_price
    end

    def discount_percent_of_first_variant
      object.product_item_variants&.first&.discount_percent
    end

    def is_favorite
      return false unless current_user.present?
      current_user.wishlist&.wishlist_items.exists?(product_item_id: object.id)
    end
    
    private
    
    def base_url
      ENV['BASE_URL'] || 'http://localhost:3000'
    end    
    
    def current_user
      @instance_options[:current_user]
    end
  end