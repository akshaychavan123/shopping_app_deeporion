class Api::V2::ShippingPoliciesController < ApplicationController
  before_action :authorize_request, except: [:index, :show]
  before_action :check_user, except: [:index, :show]
  before_action :set_shipping_policy, only: [:show, :update, :destroy]

  def index
    @shipping_policies = ShippingPolicy.all
    render json: @shipping_policies, each_serializer: ShippingPolicySerializer
  end

  def show
    render json: @shipping_policy, serializer: ShippingPolicySerializer
  end

  def create
    @shipping_policy = ShippingPolicy.new(shipping_policy_params)

    if @shipping_policy.save
      render json: @shipping_policy, serializer: ShippingPolicySerializer, status: :created
    else
      render json: @shipping_policy.errors, status: :unprocessable_entity
    end
  end

  def update
    if @shipping_policy.update(shipping_policy_params)
      render json: @shipping_policy, serializer: ShippingPolicySerializer
    else
      render json: @shipping_policy.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @shipping_policy.destroy
      render json: { message: 'Succesfully deleted' }, status: :ok
    end
  end

  private

  def set_shipping_policy
    @shipping_policy = ShippingPolicy.find(params[:id])
  end

  def shipping_policy_params
    params.permit(:heading, :description)
  end

  def check_user
    unless @current_user.type == "Admin"
      render json: { errors: ['Unauthorized access'] }, status: :forbidden
    end
  end
end
