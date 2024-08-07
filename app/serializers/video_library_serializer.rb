class VideoLibrarySerializer < ActiveModel::Serializer
  attributes :id, :description, :video_link
end
