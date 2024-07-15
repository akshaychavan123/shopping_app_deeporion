class Api::V1::LandingPageController < ApplicationController  
  def categories_index
    @categories = Category.all
    render json: @categories
  end

  def sub_categories_index
    @category = Category.find(params[:id])
    @subcategories = @category.subcategories
    render json: @subcategories
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
    # @product_items = @product.product_items
    @product_items = @product.product_items.includes(:product_item_variants).all
    render json: { data: ActiveModelSerializers::SerializableResource.new(@product_items, each_serializer: ProductItemSerializer)}
  end

  def product_items_show
    @product_item = ProductItem.find_by(id: params[:id])
    render json: { data: ActiveModelSerializers::SerializableResource.new(@product_item, each_serializer: ProductItemSerializer)}
  end

  def product_items_filter
    @product_items = ProductItem.includes(:product_item_variants).all
    # @product_items = ProductItem.includes(product: :subcategory)

    if params[:subcategory_id].present?   ##
      # @product_items = @product_items.joins(product: :subcategory).where(products: { subcategory_id: params[:subcategory_id] })
      @product_items = @product_items.where(products: { subcategory_id: params[:subcategory_id] })
    end

    if params[:product_id].present?
      @product_items = @product_items.where(product_id: params[:product_id])
    end

    @product_items = @product_items.where(brand: params[:brand]) if params[:brand].present?

    @product_items = @product_items.where(size: params[:size]) if params[:size].present?

    @product_items = @product_items.where(color: params[:color]) if params[:color].present?

    if params[:min_price].present? && params[:max_price].present?
      @product_items = @product_items.where(price: params[:min_price]..params[:max_price])
    elsif params[:min_price].present?
      @product_items = @product_items.where('price >= ?', params[:min_price])
    elsif params[:max_price].present?
      @product_items = @product_items.where('price <= ?', params[:max_price])
    end

    # Search by name or description
    # if params[:search].present?
    #   search_term = "%#{params[:search]}%"
    #   @product_items = @product_items.where('name LIKE ? OR description LIKE ?', search_term, search_term)
    # end

    render json: { data: ActiveModelSerializers::SerializableResource.new(@product_items, each_serializer: ProductItemSerializer) }, status: :ok
  end

end