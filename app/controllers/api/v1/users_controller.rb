class Api::V1::UsersController < ApplicationController
  before_action :authorize_request, except: :create
  before_action :find_user, except: %i[create]

  def index
    page = params[:page].to_i.positive? ? params[:page].to_i : 1
    per_page = params[:per_page].to_i.positive? ? params[:per_page].to_i : 10
    query_param = params[:query]
    @users = User.where(type: "Admin").ransack(search_params(query_param)).result(distinct: true)
    begin
      pagy, @users = pagy(@users, items: per_page, page: page)
    rescue Pagy::OverflowError
      last_page = (@users.count / per_page.to_f).ceil
      pagy, @users = pagy(@users, items: per_page, page: last_page)
    end
    users_data = @users.map do |user|
      {
        id: user.id,
        first_name: user.name,
        email: user.email,
        profile_picture: user.image.attached? ? url_for(user.image) : nil
      }
    end
    render json: {
      users: users_data,
      total_count: pagy.count,
      current_page: pagy.page,
      per_page: per_page
    }
  end

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
    @user.twitter = params[:twitter_link] if params[:twitter_link].present? && !params[:twitter_link].strip.empty?
    @user.google = params[:google_link] if params[:google_link].present? && !params[:google_link].strip.empty?
    
    if @user.save
      render json: { user: @user }, status: :ok
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @user = User.find_by(id: params[:id])
    if @user.present?
      @user.destroy
      render json: { message: "Account deleted" }, status: :ok
    else
      render json: { error: 'Account not found' }, status: :unprocessable_entity
    end
  end

  def show_profile
    @user = @current_user
    render json: {
      data: ActiveModelSerializers::SerializableResource.new(@user, each_serializer: UserSerializer)
  }
  end

  def user_details
    render json: @user, serializer: UserDetailSerializer
  end

  def update_password
    if @current_user.authenticate(params[:current_password])
      if @current_user.update(password_params)
        render json: { message: 'Password updated successfully' }, status: :ok
      else
        render json: { errors: @current_user.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Current password is incorrect' }, status: :unauthorized
    end
  end

  def update_personal_details
    if @current_user.update(personal_details_params)
      render json: { user: @current_user }, status: :ok
    else
      render json: { errors: @current_user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def personal_details_params
    params.permit(:name, :email, :phone_number, :gender, :user_params)
  end

  def password_params
    params.permit(:password, :password_confirmation)
  end

  def find_user
    @user = @current_user
  end

  def user_params
    params.permit(:name, :email, :password, :terms_and_condition)
  end

  def search_params(query_param)
    fields_to_search = %w[ name email ]
    search_conditions = fields_to_search.map do |field|
      { "#{field}_cont" => query_param }
    end
    { 'combinator' => 'or', 'groupings' => search_conditions }
  end
end
