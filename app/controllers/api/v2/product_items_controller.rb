class Api::V2::ProductItemsController < ApplicationController
  before_action :authorize_request
  before_action :set_product_items, only: [:show, :update, :destroy]

  def index
    @product_items = ProductItem.all
    render json: ProductItemSerializer.new(@product_items).serialized_json
  end


  def show
    @product_item = ProductItem.find(params[:id])
    render json: ProductItemSerializer.new(@product_item).serialized_json
  end
  
  def create
    @product = Product.find_by(id: params[:product_id])
    @product_item = @product.product_items.new(product_items_params)
  
    if params[:images].present?
      params[:images].each do |image|
        @product_item.images.attach(image)
      end
    end
  
    if @product_item.save
      render json: @product_item, status: :created
    else
      render json: @product_item.errors, status: :unprocessable_entity
    end
  end
  

  def update
    if @product_item.update(product_items_params)
      render json: @product_item
    else
      render json: @product_item.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @product_item.destroy
    head :no_content  
  end

  private

  def product_items_params
    params.permit(:name, :brand, :price, :discounted_price, :description, :size, :material, :care, :product_code, images: [])
  end  

  def set_product_items
    @product_item = ProductItem.find(params[:id])
  end

end
