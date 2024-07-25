class Api::V1::LandingPageController < ApplicationController  
  def categories_index
    @categories = Category.all
    render json: @categories
  end

  def product_items_by_category
    @category = Category.find(params[:id])
    @product_items = ProductItem.joins(product: { subcategory: :category }).where(categories: { id: @category.id })
    render json: { data: ActiveModelSerializers::SerializableResource.new(@product_items, each_serializer: ProductItem2Serializer) }
  end

  def index_with_subcategories_and_products
    @categories = Category.includes(subcategories: :products).all
    render json: @categories, include: { subcategories: { include: :products } }
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

  def product_items_of_product
    @product = Product.find_by(id: params[:id])
    @product_items = @product.product_items.includes(:product_item_variants).all
    render json: { data: ActiveModelSerializers::SerializableResource.new(@product_items, each_serializer: ProductItemSerializer)}
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
    @product_items = ProductItem.includes(:product_item_variants).all
  
    if params[:subcategory_id].present?
      @product_items = @product_items.joins(product: :subcategory).where(products: { subcategory_id: params[:subcategory_id] })
    end
  
    if params[:product_id].present?
      @product_items = @product_items.where(product_id: params[:product_id])
    end
  
    @product_items = @product_items.where(brand: params[:brand]) if params[:brand].present?
  
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
      @product_items = @product_items.where('name LIKE ? OR product_code LIKE ?', search_term, search_term)
    end
  
    render json: { data: ActiveModelSerializers::SerializableResource.new(@product_items, each_serializer: ProductItemSerializer) }, status: :ok
  end  

end