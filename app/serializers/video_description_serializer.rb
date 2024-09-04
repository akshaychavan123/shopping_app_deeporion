class VideoDescriptionSerializer < ActiveModel::Serializer
  attributes :id, :description
  has_many :video_libraries, serializer: VideoLibrarySerializer do
    object.video_libraries.order(created_at: :desc)
  end
end
