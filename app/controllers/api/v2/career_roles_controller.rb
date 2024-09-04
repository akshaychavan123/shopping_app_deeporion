class Api::V2::CareerRolesController < ApplicationController
    before_action :authorize_request, except: [:index, :show]
    before_action :check_user, except: [:index, :show]
    before_action :set_career, only: [:show, :update, :destroy]
  
    def index
      @careers = CareerRole.all
      render json: @careers, each_serializer: CareerRoleSerializer
    end
  
    def show
      render json: @career, serializer: CareerRoleSerializer
    end
  
    def create
      @career = CareerRole.new(careerrole_params)
  
      if @career.save
        render json: @career, serializer: CareerRoleSerializer, status: :created
      else
        render json: @career.errors, status: :unprocessable_entity
      end
    end
  
    def update
      if @career.update(careerrole_params)
        render json: @career, serializer: CareerRoleSerializer
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
      render json: { errors: ['Career not found'] }, status: :not_found
    rescue StandardError => e
      render json: { errors: [e.message] }, status: :internal_server_error
    end
  
    private
  
    def set_career
      @career = CareerRole.find(params[:id])
    end

    def careerrole_params
      params.require(:career_role).permit(:id, :role_name, :role_type, :career_id, :location, :role_overview, :key_responsibility, :requirements, :email_id, :_destroy)
    end
  
    def check_user
      unless @current_user.type == "Admin"
        render json: { errors: ['Unauthorized access'] }, status: :forbidden
      end
    end
end
