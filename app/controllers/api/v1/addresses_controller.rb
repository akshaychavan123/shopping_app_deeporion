class Api::V1::AddressesController < ApplicationController
  before_action :authorize_request
  before_action :find_user
  before_action :set_address, only: [:show, :update, :destroy]

  def index
    @addresses = @user.addresses
    render json: { addresses: @addresses }, status: :ok
  end

  def show
    render json: { address: @address }, status: :ok
  end

  def create
    location_data = fetch_city_state_for_pincode(address_params[:pincode])

    if location_data[:error]
      return render json: { errors: 'Please enter a valid pincode' }, status: :unprocessable_entity
    end

    if location_data[:city].downcase != address_params[:city].downcase
      return render json: { errors: "City does not match the pincode" }, status: :unprocessable_entity
    end

    @address = @user.addresses.build(address_params.merge(city: location_data[:city], state: location_data[:state]))
    
    if @address.save
      render json: { message: 'Address was successfully created.', address: @address }, status: :created
    else
      render json: { errors: @address.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    location_data = fetch_city_state_for_pincode(address_params[:pincode])

    if location_data[:error]
      return render json: { errors: 'Please enter a valid pincode' }, status: :unprocessable_entity
    end

    if location_data[:city].downcase != address_params[:city].downcase
      return render json: { errors: "City does not match the pincode" }, status: :unprocessable_entity
    end

    if @address.update(address_params.merge(city: location_data[:city], state: location_data[:state]))
      render json: { message: 'Address was successfully updated.', address: @address }, status: :ok
    else
      render json: { errors: @address.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @address.destroy
      render json: { message: 'Address was successfully deleted.' }, status: :ok
    else
      render json: { errors: 'Failed to delete the address.' }, status: :unprocessable_entity
    end
  end

  private

  def find_user
    @user = @current_user
  end

  def address_params
    params.permit(:first_name, :last_name, :phone_number, :email, :country, :pincode, :area, :state, :address, :city, :address_type, :default)
  end


  def set_address
    @address = @user.addresses.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { errors: 'Address not found' }, status: :not_found
  end

  def fetch_city_state_for_pincode(pincode)

    url = URI("https://api.postalpincode.in/pincode/#{pincode}")
    response = Net::HTTP.get(url)
    data = JSON.parse(response)
    if data.first["Status"] == "Error"
      return { error: "Invalid Pincode" }
    else
      post_office = data.first["PostOffice"].first
      city = post_office["District"]
      state = post_office["State"]
      { city: city, state: state }
    end
  end
end
