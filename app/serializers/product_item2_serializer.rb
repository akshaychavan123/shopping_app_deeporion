class ProductItem2Serializer < ActiveModel::Serializer
    attributes :id, :name, :brand, :price, :rating_and_review, :image, :price_of_first_variant, :is_favorite, :product_item_variants
    has_many :product_item_variants, serializer: ProductItemVariantSerializer

    def image
      object.image.attached? ? "#{base_url}#{Rails.application.routes.url_helpers.rails_blob_path(object.image, only_path: true)}" : nil
    end

    def rating_and_review
      nil
    end

    def price_of_first_variant
      object.product_item_variants&.first&.price
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