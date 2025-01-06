class Api::V2::CareerRolesController < ApplicationController
    before_action :authorize_request, except: [:index, :show]
    before_action :check_user, except: [:index, :show]
    before_action :set_career, only: [:show, :update, :destroy]
  
    def index
      @career_roles = CareerRole.all
      render json: @career_roles, each_serializer: CareerRoleSerializer
    end
  
    def show
      render json: @career_role, serializer: CareerRoleSerializer
    end
  
    def create
      @career_role = CareerRole.new(careerrole_params)
  
      if @career_role.save
        render json: @career_role, serializer: CareerRoleSerializer, status: :created
      else
        render json: @career_role.errors, status: :unprocessable_entity
      end
    end
  
    def update
      if @career_role.update(careerrole_params)
        render json: @career_role, serializer: CareerRoleSerializer
      else
        render json: @career_role.errors, status: :unprocessable_entity
      end
    end
  
    def destroy
      if @career_role.destroy
        head :no_content
      else
        render json: { errors: @career_role.errors.full_messages }, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordNotFound
      render json: { errors: ['career role not found'] }, status: :ok
    rescue StandardError => e
      render json: { errors: [e.message] }, status: :internal_server_error
    end
  
    private
  
    def set_career
      @career_role = CareerRole.find(params[:id])
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
