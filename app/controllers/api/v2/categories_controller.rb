class Api::V2::CategoriesController < ApplicationController
  before_action :authorize_request
  before_action :check_user
  before_action :set_category, only: [:show, :update, :destroy]

  def index
    @categories = Category.all
    render json: @categories
  end

  def show
    render json: @category
  end

  def create
    @category = Category.new(category_params)
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
    params.require(:category).permit(:name)
  end

  def check_user
    unless @current_user.type == "Admin"
      render json: { errors: ['Unauthorized access'] }, status: :forbidden
    end
  end
end
