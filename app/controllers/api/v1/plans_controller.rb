class Api::V1::PlansController < ApplicationController
  before_action :set_plan, only: [:show, :update, :destroy]

  def index
    @plans = Plan.all
    render json: @plans
  end

  def show
    render json: @plan
  end

  def create
    @plan = Plan.new(plan_params)
    if @plan.save
      render json: @plan, status: :created
    else
      render json: @plan.errors, status: :unprocessable_entity
    end
  end

  def update
    if @plan.update(plan_params)
      render json: @plan
    else
      render json: @plan.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @plan.destroy
    render json: { message: 'Plan deleted successfully' }, status: :ok
    rescue ActiveRecord::RecordNotDestroyed
    render json: { error: 'Failed to delete Plan' }, status: :unprocessable_entity
  end

  private

  def set_plan
    @plan = Plan.find(params[:id])
    rescue ActiveRecord::RecordNotFound
    render json: { error: 'Plan not found' }, status: :not_found
  end

  def plan_params
    params.require(:plan).permit(:name, :service, :amount, :frequency, :discription)
  end

  def check_user
    unless @current_user.type == "Admin"
      render json: { errors: ['Unauthorized access'] }, status: :forbidden
    end
  end
end
