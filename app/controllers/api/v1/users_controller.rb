class Api::V1::UsersController < ApplicationController
  before_action :authorize_request, except: :create
  before_action :find_user, except: %i[create]

  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user.to_json, status: :ok
    else
      render json: { errors: @user.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def update_image
    @user = @current_user

    @user.save(validate: false)
    if params[:image].present?
      @user.image.attach(params[:image])

      if @user.image.attached?
        image_url = url_for(@user.image)
        render json: { user: @user, image_url: image_url }, status: :ok
      else
        render json: { error: 'Failed to attach image' }, status: :unprocessable_entity
      end
    else
      render json: { error: 'No image uploaded' }, status: :unprocessable_entity
    end
    @user.save(validate: true)
  end

  def delete_image
    @user.image.purge if @user.image.attached?
    render json: { status: 'ok', user: @user }, status: :ok
  end
  
  def update_profile
    @user = @current_user
  
    @user.bio = params[:bio] if params[:bio].present? && !params[:bio].strip.empty?
    @user.facebook = params[:facebook_link] if params[:facebook_link].present? && !params[:facebook_link].strip.empty?
    @user.linkedin = params[:linkedin_link] if params[:linkedin_link].present? && !params[:linkedin_link].strip.empty?
    @user.instagram = params[:instagram_link] if params[:instagram_link].present? && !params[:instagram_link].strip.empty?
    @user.youtube = params[:youtube_link] if params[:youtube_link].present? && !params[:youtube_link].strip.empty?
  
    if @user.save
      render json: { user: @user }, status: :ok
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show_profile
    @user = @current_user
    render json: {
      data: ActiveModelSerializers::SerializableResource.new(@user, each_serializer: UserSerializer)
  }
  end

  def user_details
    render json: {
      data: ActiveModelSerializers::SerializableResource.new(@user, each_serializer: UserDetailSerializer)
  }
  end


  private

  def find_user
    @user = @current_user
  end

  def user_params
    params.permit(:name, :email, :password, :terms_and_condition)
  end
end
