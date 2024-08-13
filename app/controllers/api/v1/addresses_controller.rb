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
    @address = @user.addresses.build(address_params)
    if @address.save
      render json: { message: 'Address was successfully created.', address: @address }, status: :created
    else
      render json: { errors: @address.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @address.update(address_params)
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
end
