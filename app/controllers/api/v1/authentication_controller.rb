class Api::V1::AuthenticationController < ApplicationController

  def login
    @user = User.find_by_email(params[:email])
    if @user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: @user.id)
      render json: { token: token, username: @user.name }
    else
      render json: { error: 'unauthorized' }
    end
  end

  private

  def login_params
    params.permit(:email, :password)
  end
end
