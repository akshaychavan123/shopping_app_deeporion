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

  private

  def contact_us_params
    params.permit(:name, :email, :contact_number, :subject, :details)
  end
end
