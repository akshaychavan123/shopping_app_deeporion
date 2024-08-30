class VideoLibrary < ApplicationRecord
  belongs_to :video_description
  validates :video_link, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), message: 'must be a valid URL' }
end
