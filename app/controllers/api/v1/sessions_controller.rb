class Api::V1::SessionsController < ApplicationController

	def google_auth
		auth = request.env['omniauth.auth']
		# auth = request.env["RAW_POST_DATA"]


		# auth = {
    #   'uid' => '1234567890', # Replace with actual UID
    #   'provider' => 'google',
    #   'info' => {
    #     'name' => 'John Doe',
    #     'email' => 'user2@example.com'
    #     # Add other info fields as needed
    #   }
    # }
	
		if auth.nil?
			render json: { error: 'OAuth authentication data not received' }, status: :unprocessable_entity
			return
		end
	
    @user = User.find_or_initialize_by(uid: auth['uid'], provider: auth['provider']) do |u|
			u.name = auth['info']['name']
			u.email = auth['info']['email']
			u.password = SecureRandom.hex(10)
		end
	
		if @user.save
			payload = { user_id: @user.id }
			token = JWT.encode(payload, Rails.application.secrets.secret_key_base, 'HS256')
			render json: { jwt: token, user: @user }, status: :ok
		else
			render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
		end
	end
	
end
