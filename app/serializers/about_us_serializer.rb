class AboutUsSerializer < ActiveModel::Serializer
  attributes :id, :heading, :description, :images
  
  def images
    object.images.map do |photo|
      "#{base_url}#{Rails.application.routes.url_helpers.rails_blob_path(photo, only_path: true)}"
    end
  end

  private

  def base_url
    ENV['BASE_URL'] || 'http://localhost:3000'
  end   
end