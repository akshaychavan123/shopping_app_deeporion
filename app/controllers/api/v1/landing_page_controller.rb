class Api::V1::LandingPageController < ApplicationController  
  before_action :set_current_user, only: [:product_items_filter, :product_items_search, :product_items_by_category, :product_items_show, :product_items_of_product, :new_arrivals, :product_items_by_sub_category]

  def categories_index
    @categories = Category.all
    render json: @categories
  end

  def index_with_subcategories_and_products
    @categories = Category.includes(subcategories: :products).all
    render json: @categories, each_serializer: CategorySerializer
  end
  
  def product_items_by_category
    @category = Category.find(params[:id])    
    @product_items = ProductItem.joins(:product_item_variants)
    .joins(product: { subcategory: :category })
    .where(categories: { id: @category.id })
    .distinct
    .page(params[:page])
    .per(params[:per_page])

    render json: {
      data: ActiveModelSerializers::SerializableResource.new(@product_items, each_serializer: ProductItem2Serializer, current_user: @current_user),
      meta: pagination_meta(@product_items)
    }
  end

  def product_items_by_sub_category
    @subcategory = Subcategory.find(params[:id])
    @product_items = ProductItem.joins(:product_item_variants)
    .joins(:product)
    .where(products: { subcategory_id: @subcategory.id })
    .distinct
    .page(params[:page])
    .per(params[:per_page])
    render json: {
      data: ActiveModelSerializers::SerializableResource.new(@product_items, each_serializer: ProductItem2Serializer, current_user: @current_user),
      meta: pagination_meta(@product_items)
    }
  end

  def new_arrivals
    @new_arrivals = ProductItem.joins(:product_item_variants)
    .new_arrivals
    .includes(:product)
    .distinct

    if @new_arrivals.any?
      render json: { data: ActiveModelSerializers::SerializableResource.new(@new_arrivals, each_serializer: ProductItem2Serializer, current_user: @current_user) }, status: :ok
    else
      render json: { errors: ['No new arrivals found'] }, status: :not_found
    end
  end

  def top_category
    @top_category = Product.top_category.includes(:subcategory)

    if @top_category.any?
      render json: { data: ActiveModelSerializers::SerializableResource.new(@top_category, each_serializer: ProductSerializer)}
    else
      render json: { errors: ['No new arrivals found'] }, status: :not_found
    end
  end

  def product_items_index
    @product_items = ProductItem.includes(:product_item_variants).all
    render json: { data: ActiveModelSerializers::SerializableResource.new(@product_items, each_serializer: ProductItemSerializer)}
  end

  def gift_cards_index
    @gift_cards = GiftCard.all
    render json: { data: ActiveModelSerializers::SerializableResource.new(@gift_cards, each_serializer: GiftCardSerializer)}
  end

  def gift_cards_category
    @gift_card_categories = GiftCardCategory.all
    render json: @gift_card_categories
  end

  def gift_cards_by_category
    @gift_card_categorie = GiftCardCategory.find_by(id: params[:id])
    @gift_cards = @gift_card_categorie.gift_cards
    render json: { data: ActiveModelSerializers::SerializableResource.new(@gift_cards, each_serializer: GiftCardSerializer)}
  end

  def product_items_of_product
    @product = Product.find_by(id: params[:id])
    
    if @product
      @product_items = @product.product_items
      .joins(:product_item_variants)
      .distinct
      .page(params[:page])
      .per(params[:per_page])
      
      render json: {
        data: ActiveModelSerializers::SerializableResource.new(@product_items, each_serializer: ProductItem2Serializer, current_user: @current_user),
        meta: pagination_meta(@product_items)
      }
    else
      render json: { error: 'Product not found' }, status: :not_found
    end
  end
  

  def product_items_show
    @product_item = ProductItem.includes(:product_item_variants).find_by(id: params[:id])

    if @product_item
      review_summary = calculate_review_summary(@product_item.id)
      render json: { data: ActiveModelSerializers::SerializableResource.new(@product_item, serializer: ProductItemSerializer, current_user: @current_user), summary: review_summary }
    else
      render json: { errors: ['Product item not found'] }, status: :not_found
    end
  end
  
  def product_items_filter
  
    if params[:search].present? && params[:search].strip.empty?
      return render json: { errors: ['Search term cannot be blank'] }, status: :unprocessable_entity
    end
  
    @product_items = ProductItem.joins(:product_item_variants)
    .joins(product: { subcategory: :category })
    .distinct
  
    if params[:category_id].present?
      @product_items = @product_items.where(categories: { id: params[:category_id] })
    end

    subcategory_ids = params[:subcategory_ids]&.split(',') || []
    if subcategory_ids.any?
      @product_items = @product_items.where(products: { subcategory_id: subcategory_ids })
    end

    if params[:product_ids].present?
      product_ids = params[:product_ids].split(',')
      @product_items = @product_items.where(product_id: product_ids)
    end

    if params[:brands].present?
      brands = params[:brands].split(',').map(&:downcase)
      @product_items = @product_items.where('LOWER(product_items.brand) IN (?)', brands)
    end

    if params[:sizes].present?
      sizes = params[:sizes].split(',').map(&:downcase)
      @product_items = @product_items.joins(:product_item_variants)
                                     .where('LOWER(product_item_variants.size) IN (?)', sizes)
                                     .distinct
    end

    if params[:colors].present?
      colors = params[:colors].split(',').map(&:downcase)
      @product_items = @product_items.where('LOWER(product_items.color) IN (?)', colors).distinct
    end    

    if params[:price_ranges].present?
      price_ranges = params[:price_ranges].split(',')
    
      price_conditions = price_ranges.map do |range|
        min_price, max_price = range.split('-').map(&:to_f)
        "(product_item_variants.price BETWEEN #{min_price} AND #{max_price})"
      end
      @product_items = @product_items.where(price_conditions.join(' OR '))
    end
    
    if params[:search].present?
      search_term = "%#{params[:search].downcase}%"
      @product_items = @product_items.where('LOWER(product_items.name) LIKE :search_term OR LOWER(product_items.brand) LIKE :search_term OR LOWER(product_items.material) LIKE :search_term', search_term: search_term)
    end
  
    case params[:sort_by]
    when 'newest'
      @product_items = @product_items.order(created_at: :desc).limit(1)
    when 'recommended'
      @product_items = @product_items.order(created_at: :desc).limit(2)
    when 'rating'
      max_rating = @product_items
      .joins("LEFT JOIN reviews ON reviews.product_item_id = product_items.id")
      .group("product_items.id")
      .having("COUNT(reviews.id) > 0")
      .average("reviews.star")
      .values
      .map(&:to_f)
      .max

      @product_items = @product_items
      .joins("LEFT JOIN reviews ON reviews.product_item_id = product_items.id")
      .group("product_items.id")
      .having("AVG(reviews.star) = ?", max_rating)
      .order("AVG(reviews.star) DESC")
    when 'discount'
      coupon_ids = Coupon.where("end_date > ? AND promo_type = ?", Time.current, 'discount on product').pluck(:id)
      product_ids = Coupon.where(id: coupon_ids).pluck(:product_ids).flatten.uniq
        @product_items = @product_items
        .joins("INNER JOIN coupons ON coupons.product_ids @> ARRAY[product_items.product_id]::integer[]") 
        .where(product_id: product_ids)
        .select("product_items.*, COALESCE(MAX(coupons.amount_off), 0) AS max_discount")
        .group("product_items.id")
        .order("max_discount DESC")
    when 'price_asc'
      @product_items = @product_items
        .joins(:product_item_variants)
        .select('product_items.*, MIN(product_item_variants.price) AS variant_price')
        .group('product_items.id')
        .order('variant_price ASC')
    when 'price_desc'
      @product_items = @product_items
        .joins(:product_item_variants)
        .select('product_items.*, MIN(product_item_variants.price) AS variant_price')
        .group('product_items.id')
        .order('variant_price DESC')
    end
    
    @product_items = @product_items.page(params[:page]).per(params[:per_page])
  
    if @product_items.any?
      render json: {
        data: ActiveModelSerializers::SerializableResource.new(@product_items, each_serializer: ProductItem2Serializer, current_user: @current_user),
       meta: pagination_meta(@product_items)
      }, status: :ok
    else
      render json: { message: "" }, status: :ok
    end
  end
  
  def product_items_search
    @product_items = ProductItem.joins(:product_item_variants).distinct

    if params[:search].present?
      search_term = "%#{params[:search].downcase}%"
      @product_items = @product_items.where('LOWER(product_items.name) LIKE :search_term OR LOWER(product_items.brand) LIKE :search_term OR LOWER(product_items.material) LIKE :search_term', search_term: search_term)
    end
    
    @product_items = @product_items.page(params[:page]).per(params[:per_page])

    if @product_items.any?
      render json: {
        data: ActiveModelSerializers::SerializableResource.new(@product_items, each_serializer: ProductItem2Serializer, current_user: @current_user),
        meta: pagination_meta(@product_items)
      }, status: :ok
    else
      render json: { errors: ['No product items found'] }, status: :not_found
    end
  end

  private

  def pagination_meta(collection)
    {
      current_page: collection.current_page,
      next_page: collection.next_page,
      prev_page: collection.prev_page,
      total_pages: collection.total_pages,
      total_count: collection.total_count
    }
  end

  def calculate_review_summary(id)
    reviews = Review.where(product_item_id: id)
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
end