class ProductItemForReviewSerializer < ActiveModel::Serializer
    attributes :id, :category_id, :subcategory_id, :name, :image

    def category_id
      object.product&.subcategory&.category_id
    end

    def subcategory_id
      object.product&.subcategory_id
    end

    def image
      if object.image.attached?
        host = base_url
        Rails.env.development? || Rails.env.test? ?
          "#{host}#{Rails.application.routes.url_helpers.rails_blob_path(object.image, only_path: true)}" :
          object.image.service.send(:object_for, object.image.key).public_url
      end
    end  

    has_many :reviews, serializer: AdminReviewSerializer
    
    private
    
    def base_url
      ENV['BASE_URL'] || 'http://localhost:3000'
    end    
    
    def current_user
      @instance_options[:current_user]
    end
  end