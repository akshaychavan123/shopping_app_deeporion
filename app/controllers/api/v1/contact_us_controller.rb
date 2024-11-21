class Api::V1::ContactUsController < ApplicationController
  before_action :authorize_request
  
  def create
    @contact_us = ContactUs.new(contact_us_params)
    @contact_us.status = 'in_progress'
    
    if @contact_us.save
      render json: { message: "Thank you for your contact, our team will get back to you soon." }, status: :created
    else
      render json: { error: @contact_us.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def contact_us_params
    params.permit(:name, :email, :contact_number, :subject, :details)
  end
end
