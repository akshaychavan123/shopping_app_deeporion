class Api::V2::ContactUsManageController < ApplicationController
  before_action :authorize_request
  before_action :check_user

  def index
    contact_us_list = ContactUs.order(created_at: :desc)
  
    formatted_contact_us = contact_us_list.map do |contact_us|
      {
        id: contact_us.id,
        name: contact_us.name,
        email: contact_us.email,
        contact_number: contact_us.contact_number,
        subject: contact_us.subject,
        details: contact_us.details,
        status: contact_us.status,
        created_date: contact_us.created_at.strftime('%Y-%m-%d'), 
        created_time: contact_us.created_at.strftime('%H:%M:%S') 
      }
    end
    render json: { message: 'ContactUs entry details', list: formatted_contact_us }, status: :ok
  end
  
  def show
    contact_us_entry = ContactUs.find(params[:id])
    render json: { message: 'ContactUs entry details', data: contact_us_entry }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { message: [] }, status: :ok
  end

  def update
    contact_us_entry = ContactUs.find(params[:id])

    if contact_us_entry.update(update_params)
      render json: { message: 'ContactUs entry updated successfully', data: contact_us_entry }, status: :ok
      ContactUsMailer.contact_us_resolved(contact_us_entry).deliver_now
      # send_sms_notification(contact_us_entry) SMS Notifications paused
    else
      render json: { message: 'Failed to update ContactUs entry', errors: contact_us_entry.errors.full_messages }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { message: 'ContactUs entry not found' }, status: :ok
  end

  def destroy
    contact_us_entry = ContactUs.find(params[:id])

    if contact_us_entry.destroy
      render json: { message: 'ContactUs entry deleted successfully' }, status: :ok
    else
      render json: { message: 'Failed to delete ContactUs entry', errors: contact_us_entry.errors.full_messages }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    render json: { message: 'ContactUs entry not found' }, status: :ok
  end

  private

  def check_user
    unless @current_user.type == "Admin"
      render json: { errors: ['Unauthorized access'] }, status: :forbidden
    end
  end

  def update_params
    params.require(:contact_us).permit(:status, :comment)
  end

  def send_sms_notification(contact_us_entry)
    twilio_phone_number = ENV['TWILIO_PHONE_NUMBER']
    account_sid = ENV['TWILIO_ACCOUNT_SID']
    twilio_auth_token = ENV['TWILIO_AUTH_TOKEN']
  
    client = Twilio::REST::Client.new(account_sid, twilio_auth_token)
  
    message = <<~MSG
      Hello #{contact_us_entry.name},
      Your query (ID: #{contact_us_entry.id}) has been updated. 
      Status: #{contact_us_entry.status}
      Comment: #{contact_us_entry.comment}
  
      Thank you for contacting us.
    MSG
  
    begin
      client.messages.create(
        from: twilio_phone_number,
        to: format_full_phone_number(contact_us_entry.contact_number),
        body: message.strip
      )
    rescue Twilio::REST::RestError => e
      Rails.logger.error "Twilio SMS Error: #{e.message}"
    end
  end
  
  def format_full_phone_number(contact_number)
    contact_number.gsub!(/\D/, '')
    if contact_number.start_with?('0')
      contact_number = contact_number[1..-1]
    end
    "+#{contact_number}"
  end  
end
