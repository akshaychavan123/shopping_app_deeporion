class AboutUsSerializer < ActiveModel::Serializer
  attributes :id, :heading, :description, :images

  def images
    host = base_url
    object.images.map do |photo|
      if Rails.env.development? || Rails.env.test?
        host + Rails.application.routes.url_helpers.rails_blob_path(photo, only_path: true)
      else
        photo.service.send(:object_for, photo.key).public_url
      end
    end
  end  

  private

  def base_url
    ENV['BASE_URL'] || 'http://localhost:3000'
  end   
end