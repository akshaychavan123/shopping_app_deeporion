class Api::V2::CareersController < ApplicationController
	before_action :authorize_request, except: [:index, :show]
  before_action :check_user, except: [:index, :show]
  before_action :set_career, only: [:show, :update, :destroy]

  def index
    @careers = Career.includes(:career_roles).all    
    render json: @careers, include: :career_roles, each_serializer: CareerSerializer
  end

  def show
    render json: @career, serializer: CareerSerializer
  end

  def create
    @career = Career.new(career_params)

    if @career.save
      render json: @career, serializer: CareerSerializer, status: :created
    else
      render json: @career.errors, status: :unprocessable_entity
    end
  end

  def update
    if @career.update(career_params)
      render json: @career, serializer: CareerSerializer
    else
      render json: @career.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @career.destroy
      head :no_content
    else
      render json: { errors: @career.errors.full_messages }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { errors: ['Career not found'] }, status: :ok
  rescue StandardError => e
    render json: { errors: [e.message] }, status: :internal_server_error
  end

  private

  def set_career
    @career = Career.includes(:career_roles).find(params[:id])
  end

  def career_params
    params.require(:career).permit(:id ,:header)
  end

  def check_user
    unless @current_user.type == "Admin"
      render json: { errors: ['Unauthorized access'] }, status: :forbidden
    end
  end
end
