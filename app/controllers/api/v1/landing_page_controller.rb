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
    @product = Product.find(params[:id])
    @product_items = @product.product_items
    render json: { data: ActiveModelSerializers::SerializableResource.new(@product_items, each_serializer: ProductItemSerializer)}
  end


  def gift_cards_index
    @gift_cards = GiftCard.all
    render json: { data: ActiveModelSerializers::SerializableResource.new(@gift_cards, each_serializer: GiftCardSerializer)}
  end

  def product_items_of_product
    @product = Product.find_by(id: params[:id])
    @product_items = @product.product_items
    render json: { data: ActiveModelSerializers::SerializableResource.new(@product_items, each_serializer: ProductItemSerializer)}
  end

  def product_items_show
    @product_item = ProductItem.find_by(id: params[:id])
    render json: { data: ActiveModelSerializers::SerializableResource.new(@product_item, each_serializer: ProductItemSerializer)}
  end


end