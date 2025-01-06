class Api::V2::ProductReviewManageController < ApplicationController
  before_action :authorize_request
  before_action :check_user
  before_action :set_category, only: [:index]
  before_action :set_review, only: [:destroy, :hide_review]

  def index
    if params[:category_id].present?
      category = Category.find_by(id: params[:category_id])
      if category
        @product_items = ProductItem.joins(:reviews)
                .joins(product: { subcategory: :category })
                .where(categories: { id: category.id })
                .where(reviews: { deleted_at: nil }) 
                .distinct
                .order(created_at: :desc)
      else
        render json: { error: 'Category not found' }, status: :ok and return
      end
    else
      @product_items = ProductItem.joins(:reviews)
              .where(reviews: { deleted_at: nil })
              .distinct
              .order(created_at: :desc)
    end
  
    categories = Category.all
  
    render json: {
      data: ActiveModelSerializers::SerializableResource.new(@product_items, each_serializer: ProductItemForReviewSerializer),
      categories: categories
    }
  end
  
  def product_reviews
    @product_item = ProductItem.find_by(id: params[:id])
  
    if @product_item.nil?
      render json: { error: 'ProductItem not found' }, status: :ok and return
    end
  
    @reviews = @product_item.reviews.active.includes(:review_votes)
  
    case params[:sort_by]
    when 'positive'
      @reviews = @reviews.where(star: 5)
    when 'negative'
      @reviews = @reviews.where(star: 1)
    when 'recent'
      @reviews = @reviews.order(created_at: :desc)
    when 'hidden'
      @reviews = @product_item.reviews.where.not(deleted_at: nil).includes(:review_votes)
    else
      @reviews = @reviews.order(created_at: :desc)
    end
  
    @reviews = @reviews.page(params[:page]).per(params[:per_page])
  
    review_summary = calculate_review_summary(@product_item.id)
  
    product_data = {
      name: @product_item.product.name,
      image_url: product_item_image_url(@product_item)
    }
  
    render json: {
      reviews: ActiveModelSerializers::SerializableResource.new(@reviews, each_serializer: AdminReviewSerializer, current_user: @current_user),
      summary: review_summary,
      product: product_data,
      meta: pagination_meta(@reviews)
    }
  end
  
  def destroy
    @review.destroy
    render json: { message: 'Review deleted successfully' }, status: :ok
  end

  def hide_review
    @review.soft_delete
    render json: { message: 'Review hide successfully' }, status: :ok
  end

  private

  def set_category
    @category = Category.find_by(id: params[:category_id])
  end

  def set_review
    @review = Review.find_by(id: params[:id])

    if @review.nil?
      render json: { error: 'Review not found' }, status: :ok
    end
  end

  def check_user
    render json: { errors: ['Unauthorized access'] }, status: :forbidden unless @current_user.type == "Admin"
  end

  def pagination_meta(collection)
    {
      current_page: collection.current_page,
      next_page: collection.next_page,
      prev_page: collection.prev_page,
      total_pages: collection.total_pages,
      total_count: collection.total_count
    }
  end

  def calculate_review_summary(product_item_id)
    reviews = Review.where(product_item_id: product_item_id)
    {
      total_review_count: reviews.count,
      average_rating: reviews.average(:star).to_f,
      one_star_count: reviews.where(star: 1).count,
      two_star_count: reviews.where(star: 2).count,
      three_star_count: reviews.where(star: 3).count,
      four_star_count: reviews.where(star: 4).count,
      five_star_count: reviews.where(star: 5).count
    }
  end

   
  def product_item_image_url(product_item)
    if product_item.image.attached?
      host = base_url
      Rails.env.development? || Rails.env.test? ?
        "#{host}#{Rails.application.routes.url_helpers.rails_blob_path(product_item.image, only_path: true)}" :
        product_item.image.service.send(:object_for, product_item.image.key).public_url
    end
  end
  
  def base_url
    ENV['BASE_URL'] || 'http://localhost:3000'
  end
end