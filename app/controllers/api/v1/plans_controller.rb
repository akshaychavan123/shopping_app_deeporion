class Api::V1::PlansController < ApplicationController
  before_action :authorize_request
  before_action :check_user, only: [:create, :update, :destroy]
  before_action :set_plan, only: [:show, :update, :destroy]

  def index
    @plans = Plan.all
    render json: @plans
  end

  def show
    render json: @plan
  end

  def create
    # Create a Razorpay plan
    ActiveRecord::Base.transaction do
      razorpay_plan = Razorpay::Plan.create({
        period: params[:period],
        interval: params[:interval],
        item: {
          name: params[:name],
          description: params[:description],
          amount: params[:amount].to_i,
          currency: params[:currency]
        }
      })

      @plan = Plan.new(
        razorpay_plan_id: razorpay_plan.id,
        name: params[:name],
        description: params[:description],
        amount: params[:amount],
        currency: params[:currency],
        period: params[:period],
        interval: params[:interval]
      )

      if @plan.save
         @plan.update(active: true)
         render json: { plan: @plan, message: 'Plan created successfully' }, status: :created
      else
        raise ActiveRecord::Rollback, @plan.errors.full_messages.join(', ')
      end
    end
    rescue Razorpay::Error => e
    render json: { error: e.message }, status: :unprocessable_entity
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

  def check_user
    unless @current_user.type == "Admin"
      render json: { errors: ['Unauthorized access'] }, status: :forbidden
    end
  end

  def plan_params
    params.require(:plan).permit(:name, :service, :amount, :frequency, :description, :active, :currency, :period, :interval)
  end
end
