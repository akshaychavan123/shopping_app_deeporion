class Api::V2::ImageUploadersController < ApplicationController
  before_action :authorize_request, except: [:images_by_name, :show, :index]
  before_action :check_user, except: [:images_by_name, :show, :index]

  def index
    @image_uploaders = ImageUploader.all
    render json: { data: ActiveModelSerializers::SerializableResource.new(@image_uploaders, each_serializer: ImageUploaderSerializer)}
  end

  def images_by_name
    @image_uploaders = ImageUploader.where(name: params[:name])
    render json: { data: ActiveModelSerializers::SerializableResource.new(@image_uploaders, each_serializer: ImageUploaderSerializer)}
  end

  def show
    @image_uploader = ImageUploader.find(params[:id])
    render json: @image_uploader, serializer: ImageUploaderSerializer
  end

  def create
    @image_uploader = ImageUploader.new(image_uploader_params)

    if params[:images].present?
      Array(params[:images]).each do |photo|
        @image_uploader.images.attach(photo)
      end
    end
    
    if @image_uploader.save
      render json: @image_uploader, serializer: ImageUploaderSerializer, status: :created
    else
      render json: @image_uploader.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @image_uploader = ImageUploader.find(params[:id])
    if @image_uploader.destroy
      render json: { message: 'Succesfully deleted' }, status: :ok
    end
  end

  private

  def check_user
    unless @current_user.type == "Admin"
      render json: { errors: ['Unauthorized access'] }, status: :forbidden
    end
  end

  def image_uploader_params
    params.permit(:name)
  end
end