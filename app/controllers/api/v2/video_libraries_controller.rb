class Api::V2::VideoLibrariesController < ApplicationController
  before_action :authorize_request, except: [:index, :show]
  before_action :check_user, except: [:index, :show]
  before_action :set_video_library, only: [:show, :update, :destroy]

  def index
    @video_libraries = VideoLibrary.all
    render json: @video_libraries, each_serializer: VideoLibrarySerializer
  end

  def show
    render json: @video_library, serializer: VideoLibrarySerializer
  end

  def create
    @video_library = VideoLibrary.new(video_library_params)

    if @video_library.save
      render json: @video_library, serializer: VideoLibrarySerializer, status: :created
    else
      render json: @video_library.errors, status: :unprocessable_entity
    end
  end

  def update
    if @video_library.update(video_library_params)
      render json: @video_library, serializer: VideoLibrarySerializer
    else
      render json: @video_library.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @video_library.destroy
      render json: { message: 'Succesfully deleted' }, status: :ok
    end
  end

  private

  def set_video_library
    @video_library = VideoLibrary.find(params[:id])
  end

  def video_library_params
    params.permit(:description, :video_link)
  end

  def check_user
    unless @current_user.type == "Admin"
      render json: { errors: ['Unauthorized access'] }, status: :forbidden
    end
  end
end
