class Api::V2::BannersController < ApplicationController
	before_action :authorize_request, only: [:create, :update, :destroy]
	before_action :set_banner, only: [:show, :update, :destroy]
	before_action :check_user, only: [:create, :update, :destroy]

	def index
    banners = Banner.all
    render json: banners, each_serializer: BannerSerializer, status: :ok
  end

	def show
    render json: @banner, serializer: BannerSerializer, status: :ok
  end

	def create
    @banner = Banner.new(banner_params)
    if @banner.save
      attach_images if params[:images].present?
      render json: { data: BannerSerializer.new(@banner) }, status: :created
    else
			render json: { message: 'Something went wrong' }, status: :unprocessable_entity
    end
  end

  def update
    if @banner.update(banner_params)
      attach_images if params[:images].present?
      render json: { data: BannerSerializer.new(@banner) }, status: :ok
    else
			render json: { message: 'Something went wrong' }, status: :unprocessable_entity
    end
  end

	def destroy
		@banner.destroy
		render json: { message: 'Banner destroy successfully' }, status: :ok
	end

	private

	def set_banner
		@banner = Banner.find(params[:id])
	end

	def banner_params
		params.permit(:heading, :description, :banner_type, images: [])
	end

	def attach_images
    Array(params[:images]).each do |image|
      @banner.images.attach(image)
    end
  end

	def check_user
    unless @current_user.type == "Admin"
      render json: { errors: ['Unauthorized access'] }, status: :forbidden
    end
  end
end
