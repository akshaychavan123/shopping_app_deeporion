class Api::V1::AddressesController < ApplicationController
  before_action :authorize_request
  before_action :find_user
  
  def create
    @address = @user.build_address(address_params)
    if @address.save
      render json: { message: 'Address was successfully created.', address: @address }, status: :created
    else
      render json: { errors: @address.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private
  def find_user
    @user = @current_user
  end

  def address_params
    params.permit(:first_name, :last_name, :phone_number, :email, :country, :pincode, :area, :state, :address, :city, :address_type, :default)
  end
end
