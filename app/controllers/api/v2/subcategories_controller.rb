class Api::V2::SubcategoriesController < ApplicationController
	before_action :set_category
	before_action :set_subcategory, only: [:show, :update, :destroy]
  before_action :authorize_request

	def index
		@subcategories = @category.subcategories
		render json: @subcategories
	end

	def show
		render json: @subcategory
	end

	def create
		@subcategory = @category.subcategories.build(subcategory_params)
		if @subcategory.save
			render json: @subcategory, status: :created
		else
			render json: @subcategory.errors, status: :unprocessable_entity
		end
	end

	def update
		if @subcategory.update(subcategory_params)
			render json: @subcategory
		else
			render json: @subcategory.errors, status: :unprocessable_entity
		end
	end

	def destroy
		@subcategory.destroy
		head :no_content
	end

	private

	def set_category
		@category = Category.find(params[:category_id])
	end

	def set_subcategory
		@subcategory = @category.subcategories.find(params[:id])
	end

	def subcategory_params
		params.require(:subcategory).permit(:name)
	end

end
