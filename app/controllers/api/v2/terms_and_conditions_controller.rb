class Api::V2::TermsAndConditionsController < ApplicationController
	before_action :authorize_request, except: [:index, :show]
  before_action :set_terms_and_condition, only: [:show, :update, :destroy]
  before_action :check_user, except: [:index, :show]

  def index
    @terms_and_conditions = TermsAndCondition.all
    render json: @terms_and_conditions
  end

  def show
    render json: @terms_and_condition
  end

  def create
    @terms_and_condition = TermsAndCondition.new(terms_and_condition_params)
    if @terms_and_condition.save
      render json: @terms_and_condition, status: :created
    else
      render json: @terms_and_condition.errors, status: :unprocessable_entity
    end
  end

  def update
    if @terms_and_condition.update(terms_and_condition_params)
      render json: @terms_and_condition
    else
      render json: @terms_and_condition.errors, status: :unprocessable_entity
    end
  end

	def destroy
    @terms_and_condition.destroy
    render json: { message: 'Terms and Condition deleted successfully' }, status: :ok
  rescue ActiveRecord::RecordNotDestroyed
    render json: { error: 'Failed to delete Terms and Condition' }, status: :unprocessable_entity
  end

  private

  def set_terms_and_condition
    @terms_and_condition = TermsAndCondition.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Terms and Condition not found' }, status: :not_found
  end

  def terms_and_condition_params
    params.require(:terms_and_condition).permit(:content, :version)
  end

	def check_user
    unless @current_user.type == "Admin"
      render json: { errors: ['Unauthorized access'] }, status: :forbidden
    end
  end
end
