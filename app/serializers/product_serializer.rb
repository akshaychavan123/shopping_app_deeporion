class ProductSerializer < ActiveModel::Serializer
  attributes :id, :name, :category_id, :category_name, :image

  def category_id
    object.category_id if object.category.present?
  end

  def category_name
    object&.category&.name if object.category.present?
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