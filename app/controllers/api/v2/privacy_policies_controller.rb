class Api::V2::PrivacyPoliciesController < ApplicationController
  before_action :authorize_request, except: [:index, :show]
  before_action :check_user, except: [:index, :show]
  before_action :set_privacy_policy, only: [:show, :update, :destroy]

  def index
    @privacy_policies = PrivacyPolicy.all
    render json: @privacy_policies
  end

  def show
    render json: @privacy_policy
  end

  def create
    @privacy_policy = PrivacyPolicy.new(privacy_policy_params)
    if @privacy_policy.save
      render json: @privacy_policy, status: :created
    else
      render json: @privacy_policy.errors, status: :unprocessable_entity
    end
  end

  def update
    if @privacy_policy.update(privacy_policy_params)
      render json: @privacy_policy
    else
      render json: @privacy_policy.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @privacy_policy.destroy
    head :no_content
  end

  private

  def set_privacy_policy
    @privacy_policy = PrivacyPolicy.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'PrivacyPolicy not found' }, status: :not_found
  end

  def privacy_policy_params
    params.require(:privacy_policy).permit(:heading, :description)
  end

  def check_user
    unless @current_user.type == "Admin"
      render json: { errors: ['Unauthorized access'] }, status: :forbidden
    end
  end
end
