class Api::V2::AboutUsController < ApplicationController
  before_action :authorize_request, except: [:index, :show]
  before_action :check_user, except: [:index, :show]
  before_action :set_about_us, only: [:show, :update, :destroy]


  def index
    @about_uss = AboutUs.all
    render json: { data: ActiveModelSerializers::SerializableResource.new(@about_uss, each_serializer: AboutUsSerializer)}
  end

  def show
    render json: @about_us, serializer: AboutUsSerializer
  end

  def create
    @about_us = AboutUs.new(about_us_params)

    if @about_us.save
      if params[:images].present?
        Array(params[:images]).each do |photo|
          @about_us.images.attach(photo)
        end
      end
      render json: @about_us, serializer: AboutUsSerializer, status: :created
    else
      render json: @about_us.errors, status: :unprocessable_entity
    end
  end

  def update
    if @about_us.update(about_us_params)
      attach_images if params[:images].present?
      render json: @about_us, serializer: AboutUsSerializer
    else
      render json: @about_us.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @about_us.destroy
      render json: { message: 'Succesfully deleted' }, status: :ok
    end
  end

  private

  def set_about_us
    @about_us = AboutUs.find(params[:id])
  end

  def about_us_params
    params.permit(:heading, :description)
  end

  def check_user
    unless @current_user.type == "Admin"
      render json: { errors: ['Unauthorized access'] }, status: :forbidden
    end
  end

  def attach_images
    @about_us.images.purge
    Array(params[:images]).each do |photo|
      @about_us.images.attach(photo)
    end
  end
end
