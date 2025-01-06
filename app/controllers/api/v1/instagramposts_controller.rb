class Api::V1::InstagrampostsController < ApplicationController
    before_action :setinstagrampost, only: [:show, :update, :destroy]

  def index
    @instagramposts = Instagrampost.all
    render json: @instagramposts
  end

  def show
    render json: @instagramposts
  end

  def create
    @instagramposts = Instagrampost.new(insta_params)
    if @instagramposts.save
      render json: @instagramposts, status: :created
    else
      render json: @instagramposts.errors, status: :unprocessable_entity
    end
  end

  def update
    if @instagramposts.update(insta_params)
      render json: @instagramposts
    else
      render json: @instagramposts.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @instagramposts.destroy
    render json: { message: 'Plan deleted successfully' }, status: :ok
    rescue ActiveRecord::RecordNotDestroyed
    render json: { error: 'Failed to delete Plan' }, status: :unprocessable_entity
  end

  private

  def setinstagrampost
    @instagramposts = Instagrampost.find(params[:id])
    rescue ActiveRecord::RecordNotFound
    render json: { error: 'Plan not found' }, status: :ok
  end

  def check_user
    unless @current_user.type == "Admin"
      render json: { errors: ['Unauthorized access'] }, status: :forbidden
    end
  end

  def insta_params
    params.permit(:url, :description, :image)
  end
  
end
