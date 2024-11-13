class Api::V1::ContactUsController < ApplicationController
  before_action :authorize_request
  
  def create
    @contact_us = ContactUs.new(contact_us_params)
    if @contact_us.save
      render json: {message: "Thanks you for your contact, team will contact you soon."}, status: :created
    else
      render json: {error: 'Please try again'}, status: :unprocessable_entity
    end
  end

  def index
    data = ContactUs.all
    if data.present?
      render json: {data:data ,message: "Data list"}, status: :ok
    else
      render json: {error: 'Data not found'}, status: :not_found
    end
  end

  def update
    @contact_us = ContactUs.find(params[:id])
    if @contact_us.update(contact_us_params)
      render json: @contact_us
    else
      render json: @contact_us.errors, status: :unprocessable_entity
    end
  end

  private

  def contact_us_params
    params.permit(:name, :email, :contact_number, :subject, :details, :comment, :status)
  end
end
