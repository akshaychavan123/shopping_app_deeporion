class ClientReviewCommentSerializer < ActiveModel::Serializer
  attributes :id, :comment, :client_review_id

  belongs_to :client_review
  belongs_to :user, serializer: UserNameSerializer
end
