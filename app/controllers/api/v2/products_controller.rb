class Api::V2::ProductsController < ApplicationController
  before_action :set_product, only: [:show, :update, :destroy]
  before_action :authorize_request, except: [:index]
  before_action :check_user, except: [:index]

  def index
    @products = Product.order(created_at: :asc)
    render json: { data: ActiveModelSerializers::SerializableResource.new(@products, each_serializer: ProductSerializer)}
  end

  def show
    render json: { data: ActiveModelSerializers::SerializableResource.new(@product, each_serializer: ProductSerializer)}
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      if params[:image].present?
        @product.image.attach(params[:image])
      end
      render json: @product, serializer: ProductSerializer, status: :created
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  def update
    if @product.update(product_params)
      @product.image.attach(params[:image]) if params[:image].present?
      render json: @product, serializer: ProductSerializer, status: :ok
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
    params.permit(:name, :category_id)
  end

  def check_user
    unless @current_user.type == "Admin"
      render json: { errors: ['Unauthorized access'] }, status: :forbidden
    end
  end
end
