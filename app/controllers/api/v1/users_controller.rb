class Api::V1::UsersController < ApplicationController
  before_action :authorize_request, except: :create
  before_action :find_user, except: %i[create]

  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user.to_json
    else
      render json: { errors: @user.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def update_image
    if @user.update_column(:image, params[:image])
      render json: { status: 'ok', user: @user }, status: :ok
    else
      render json: { error: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def delete_image
    if @user.update_column(:image, nil)
      render json: { status: 'ok', user: @user }, status: :ok
    else
      render json: { error: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
  private

  def find_user
    @user = @current_user
  end

  def user_params
    params.permit(
      :name, :email, :password
    )
  end
end
