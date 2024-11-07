class ProductSerializer < ActiveModel::Serializer
  attributes :id, :name, :subcategory_id, :category_id, :image

  def category_id
    object.subcategory.category_id if object.subcategory.present?
  end

  def image
    if object.image.attached?
      if Rails.env.development? || Rails.env.test?
        "#{base_url}#{Rails.application.routes.url_helpers.rails_blob_path(object.image, only_path: true)}"
      else
        object.image.service.send(:object_for, object.image.key).public_url
      end
    end
  end

  private

  def base_url
    ENV['BASE_URL'] || 'http://localhost:3000'
  end   
end