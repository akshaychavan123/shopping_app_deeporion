class Api::V2::ProductsController < ApplicationController
  before_action :set_product, only: [:show, :update, :destroy]
  before_action :authorize_request
  before_action :check_user

  def index
    @products = Product.all
    render json: @products
  end

  def show
    render json: @product
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      render json: @product, status: :created
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  def update
    if @product.update(product_params)
      render json: @product
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    head :no_content  
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :subcategory_id)
  end

  def check_user
    unless @current_user.type == "Admin"
      render json: { errors: ['Unauthorized access'] }, status: :forbidden
    end
  end
end
