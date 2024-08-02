class Review2Serializer < ActiveModel::Serializer
	attributes :id, :star, :recommended, :review, :helpful_true_count, :helpful_false_count, :total_review_count

  def helpful_true_count
    object.review_votes.where(helpful: true).count
  end

  def helpful_false_count
    object.review_votes.where(helpful: false).count
  end

  def total_review_count
    Review.where(product_item_id: object.product_item_id).count
  end
end
