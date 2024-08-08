class Api::V2::ExchangeReturnPoliciesController < ApplicationController
  before_action :authorize_request, except: [:index, :show]
  before_action :check_user, except: [:index, :show]
  before_action :set_exchange_return_policy, only: [:show, :update, :destroy]

  def index
    @exchange_return_policies = ExchangeReturnPolicy.all
    render json: @exchange_return_policies, each_serializer: ExchangeReturnPolicySerializer
  end

  def show
    render json: @exchange_return_policy, serializer: ExchangeReturnPolicySerializer
  end

  def create
    @exchange_return_policy = ExchangeReturnPolicy.new(exchange_return_policy_params)

    if @exchange_return_policy.save
      render json: @exchange_return_policy, serializer: ExchangeReturnPolicySerializer, status: :created
    else
      render json: @exchange_return_policy.errors, status: :unprocessable_entity
    end
  end

  def update
    if @exchange_return_policy.update(exchange_return_policy_params)
      render json: @exchange_return_policy, serializer: ExchangeReturnPolicySerializer
    else
      render json: @exchange_return_policy.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @exchange_return_policy.destroy
      render json: { message: 'Succesfully deleted' }, status: :ok
    end
  end

  private

  def set_exchange_return_policy
    @exchange_return_policy = ExchangeReturnPolicy.find(params[:id])
  end

  def exchange_return_policy_params
    params.permit(:heading, :description)
  end

  def check_user
    unless @current_user.type == "Admin"
      render json: { errors: ['Unauthorized access'] }, status: :forbidden
    end
  end
end
