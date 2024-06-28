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

    if params[:image].present?
      @user.image.attach(params[:image])

      if @user.image.attached?
        image_url = url_for(@user.image)
        render json: { status: 'ok', user: @user, image_url: image_url }, status: :ok
      else
        render json: { error: 'Failed to attach image' }, status: :unprocessable_entity
      end
    else
      render json: { error: 'No image uploaded' }, status: :unprocessable_entity
    end
  end

  def delete_image
    @user.image.purge if @user.image.attached?
    render json: { status: 'ok', user: @user }, status: :ok
  end
  
  private

  def find_user
    @user = @current_user
  end

  def user_params
    params.permit(:name, :email, :password, :terms_and_condition)
  end
end
