class Api::V1::HelpCentersController < ApplicationController
  before_action :set_api_v1_help_center, only: %i[ show edit update destroy ]

  def index
    @help_centers = HelpCenter.all
    render json: @help_centers
  end

  def show
    render json: @help_centers
  end


  def create
    @help_centers = HelpCenter.new(api_v1_help_center_params)

    if @help_centers.save
      render json: @help_centers, status: :created
    else
      render json: @help_centers.errors, status: :unprocessable_entity
    end
  end

  def update
    if @help_centers.update(api_v1_help_center_params)
      render json: @help_centers
    else
      render json: @help_centers.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @help_centers.destroy
    render json: { message: 'Help Center deleted successfully' }, status: :ok
    rescue ActiveRecord::RecordNotDestroyed
    render json: { error: 'Failed to delete Help Center' }, status: :unprocessable_entity
  end

  private

    def set_api_v1_help_center
      @help_centers = HelpCenter.find(params[:id])
    end

    def api_v1_help_center_params
      params.require(:help_center).permit(:question, :answer, :description)
    end
end
