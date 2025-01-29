class Api::V2::CategoriesController < ApplicationController
  before_action :authorize_request
  before_action :check_user
  before_action :set_category, only: [:show, :update, :destroy]

  def index
    @categories = Category.where(parent_id: nil).includes(:subcategories)
    render json: { data: ActiveModelSerializers::SerializableResource.new(@categories, each_serializer: CategorySerializer) }
  end

  def show
    render json: @category
  end

  def create
    parent_category = Category.find_by(id: params[:parent_id]) if params[:parent_id].present?

    @category = Category.new(category_params)
    @category.parent = parent_category

    if @category.save
      render json: @category, status: :created
    else
      render json: @category.errors, status: :unprocessable_entity
    end
  end

  def update
    if @category.update(category_params)
      render json: @category
    else
      render json: @category.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @category.destroy
    render json: { message: 'Category deleted successfully.' }, status: :ok
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :parent_id)
  end

  def check_user
    unless @current_user.type == "Admin"
      render json: { errors: ['Unauthorized access'] }, status: :forbidden
    end
  end
end
