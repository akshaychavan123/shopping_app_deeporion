class Api::V1::LandingPageController < ApplicationController  
  def categories_index
    @categories = Category.all
    render json: @categories
  end

  def product_items_by_category
    @category = Category.find(params[:id])
    @product_items = ProductItem.joins(product: { subcategory: :category })
                                .where(categories: { id: @category.id })
                                .page(params[:page])
                                .per(params[:per_page])
  
    render json: {
      data: ActiveModelSerializers::SerializableResource.new(@product_items, each_serializer: ProductItem2Serializer),
      meta: pagination_meta(@product_items)
    }
  end
  
  
  def index_with_subcategories_and_products
    @categories = Category.includes(subcategories: :products).all
    render json: @categories, include: { subcategories: { include: :products } }
  end

  def index_of_product_by_category
    @category = Category.find(params[:id])
  
    if @category
      products = @category.products
      render json: products
    else
      render json: { error: 'Category not found' }, status: :not_found
    end
  end

  def new_arrivals
    @new_arrivals = ProductItem.new_arrivals.includes(:product)

    if @new_arrivals.any?
      render json: { data: ActiveModelSerializers::SerializableResource.new(@new_arrivals, each_serializer: ProductItem2Serializer) }, status: :ok
    else
      render json: { errors: ['No new arrivals found'] }, status: :not_found
    end
  end

  def products_index
    @subcategory = Subcategory.find(params[:id])
    @products = @subcategory.products
    render json: @products
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
    @product_items = @product.product_items
    render json: { data: ActiveModelSerializers::SerializableResource.new(@product_items, each_serializer: ProductItem2Serializer)}
  end

  def product_items_show
    @product_item = ProductItem.includes(:product_item_variants).find_by(id: params[:id])

    if @product_item
      render json: { data: ActiveModelSerializers::SerializableResource.new(@product_item, serializer: ProductItemSerializer) }
    else
      render json: { errors: ['Product item not found'] }, status: :not_found
    end
  end
  
  def product_items_filter
    if params[:search].present? && params[:search].strip.empty?
      return render json: { errors: ['Search term cannot be blank'] }, status: :unprocessable_entity
    end
  
    @product_items = ProductItem.joins(product: { subcategory: :category })
  
    if params[:category_id].present?
      @product_items = @product_items.where(categories: { id: params[:category_id] })
    end
  
    if params[:subcategory_id].present?
      @product_items = @product_items.where(products: { subcategory_id: params[:subcategory_id] })
    end
  
    if params[:product_id].present?
      @product_items = @product_items.where(product_id: params[:product_id])
    end
  
    if params[:brand].present?
      @product_items = @product_items.where(brand: params[:brand])
    end
  
    if params[:size].present?
      @product_items = @product_items.joins(:product_item_variants).where(product_item_variants: { size: params[:size] })
    end
  
    if params[:color].present?
      @product_items = @product_items.joins(:product_item_variants).where(product_item_variants: { color: params[:color] })
    end
  
    if params[:min_price].present? && params[:max_price].present?
      @product_items = @product_items.where(price: params[:min_price]..params[:max_price])
    elsif params[:min_price].present?
      @product_items = @product_items.where('price >= ?', params[:min_price])
    elsif params[:max_price].present?
      @product_items = @product_items.where('price <= ?', params[:max_price])
    end
  
    if params[:search].present?
      search_term = "%#{params[:search]}%"
      @product_items = @product_items.where('product_items.name LIKE :search_term OR product_items.brand LIKE :search_term OR product_item_variants.color LIKE :search_term OR product_items.material LIKE :search_term', search_term: search_term)
    end
  
    @product_items = @product_items.page(params[:page]).per(params[:per_page])
  
    if @product_items.any?
      render json: {
        data: ActiveModelSerializers::SerializableResource.new(@product_items, each_serializer: ProductItem2Serializer),
        meta: pagination_meta(@product_items)
      }, status: :ok
    else
      render json: { errors: ['No product items found'] }, status: :not_found
    end
  end
  
  def product_items_search
    @product_items = ProductItem.all

    if params[:search].present?
      search_term = "%#{params[:search].downcase}%"
      @product_items = @product_items.where('LOWER(product_items.name) LIKE :search_term OR LOWER(product_items.brand) LIKE :search_term OR LOWER(product_items.material) LIKE :search_term', search_term: search_term)
    end
    
    @product_items = @product_items.page(params[:page]).per(params[:per_page])

    if @product_items.any?
      render json: {
        data: ActiveModelSerializers::SerializableResource.new(@product_items, each_serializer: ProductItem2Serializer),
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
end