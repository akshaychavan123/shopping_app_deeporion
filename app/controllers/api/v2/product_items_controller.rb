class Api::V2::ProductItemsController < ApplicationController
  before_action :authorize_request
  before_action :check_user
  before_action :set_product_items, only: [:show, :update, :destroy]

  def index
    @product_items = ProductItem.all
    render json: { data: ActiveModelSerializers::SerializableResource.new(@product_items, each_serializer: ProductItemSerializer)}
  end

  def admin_product_list
    @product_items = ProductItem.where(product_id: params[:product_id])
    if @product_items.present?
      render json: { data: ActiveModelSerializers::SerializableResource.new(@product_items, each_serializer: ProductItemSerializer)}
    else
      render json: { message: 'Not found' }, status: :unprocessable_entity
    end
  end

  def show
    render json: { data: ActiveModelSerializers::SerializableResource.new(@product_item, each_serializer: ProductItemSerializer)}
  end

  
  def create
    @product = Product.find_by(id: params[:product_id])
    @product_item = @product.product_items.new(product_items_params)
    @product_item.product_code = generate_product_code
    if @product_item.save
      if params[:image].present?
        @product_item.image.attach(params[:image])
      end

      if params[:photos].present?
        Array(params[:photos]).each do |photo|
          @product_item.photos.attach(photo)
        end
      end

      render json: { data: ActiveModelSerializers::SerializableResource.new(@product_item, each_serializer: ProductItemSerializer)}
    else
      render json: { error: 'Something went to wrong' }, status: :unprocessable_entity
    end
  end  

  def update
    if @product_item.update(product_items_params)
      render json: { data: ActiveModelSerializers::SerializableResource.new(@product_item, each_serializer: ProductItemSerializer)}
    else
      render json: @product_item.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @product_item.present?
      @product_item.destroy
      render json: { message: 'Succesfully deleted' }, status: :ok
    else
      render json: { message: 'Not found' }, status: :unprocessable_entity
    end
  end

  private

  def product_items_params
    params.permit(:name, :brand, :price, :discounted_price, :description, :material, :care, :product_code, :care_instructions, :fabric, :hemline, :neck, :texttile_thread, :size_and_fit, :main_trend, :knite_or_woven, :length ,:height, :occasion, :color)
  end  

  def set_product_items
    @product_item = ProductItem.find_by(id: params[:id])
  end

  def check_user
    unless @current_user.type == "Admin"
      render json: { errors: ['Unauthorized access'] }, status: :forbidden
    end
  end

  def generate_product_code
    category_code = 'ITEM'
    date_str = Date.today.strftime('%Y%m%d')
    serial_number = loop do
      random_number = SecureRandom.hex(4).upcase 
      break random_number unless ProductItem.where(product_code: "#{category_code}-#{date_str}-#{random_number}").exists?
    end
    product_code = "#{category_code}-#{date_str}-#{serial_number}"
    return product_code
  end

end