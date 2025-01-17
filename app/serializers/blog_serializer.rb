class BlogSerializer < ActiveModel::Serializer
  attributes :id, :title, :category, :description, :path_name, :card_home_url, :card_insights_url, :banner_url, :body,
   :visibility, :publish_date, :card_home_url_alt, :card_insights_url_alt, :banner_url_alt

  attribute :publisher do
    if (user = User.find_by(id: object.publisher_id))
      {
        id: user.id,
        name: user.first_name + " " + user.last_name,
        profile_picture: user.profile_picture.attached? ? s3_url(user.profile_picture) : nil
      }
    else
      nil
    end
  end

  private

  def serialize_image(image)
    {
      name: image.filename.to_s,
      content_type: image.content_type,
      url: s3_url(image)
    }
  end

  def s3_url(attachment)
    return nil if attachment.nil?
  
    if Rails.env.production? || Rails.application.config.active_storage.service == :amazon
      url_parts = attachment.url.split('?', 2)
      base_url = url_parts.first
      base_url
    else
      Rails.application.routes.url_helpers.rails_blob_url(attachment, host: "localhost:3000")
    end
  end  
end  