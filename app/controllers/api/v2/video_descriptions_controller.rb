class Api::V2::VideoDescriptionsController < ApplicationController
  before_action :authorize_request, only: [:create, :update, :destroy]
  before_action :set_video_description, only: [:show, :update, :destroy]
  before_action :check_user, only: [:create, :update, :destroy]

  def index
    @video_descriptions = VideoDescription.all
    render json: @video_descriptions, each_serializer: VideoDescriptionSerializer
  end

  def show
    render json: @video_description, serializer: VideoDescriptionSerializer
  end

  def create
    @video_description = VideoDescription.new(video_description_params)
    if @video_description.save
      render json: @video_description, serializer: VideoDescriptionSerializer, status: :created
    else
      render json: { message: 'Something went wrong' }, status: :unprocessable_entity
    end
  end

  def update
    if @video_description.update(video_description_params)
      render json: @video_description, serializer: VideoDescriptionSerializer
    else
      render json: { message: 'Something went wrong' }, status: :unprocessable_entity
    end
  end

  def destroy
    @video_description.destroy
    render json: { message: 'Description destroyed successfully' }, status: :ok
  end

  private

  def set_video_description
    @video_description = VideoDescription.find(params[:id])
  end

  def video_description_params
    params.permit(:description)
  end

  def check_user
    unless @current_user.type == "Admin"
      render json: { errors: ['Unauthorized access'] }, status: :forbidden
    end
  end
end
