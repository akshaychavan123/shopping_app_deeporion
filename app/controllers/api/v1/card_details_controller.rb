class Api::V1::CardDetailsController < ApplicationController
  before_action :authorize_request
  before_action :find_card_detail, only: [:update, :destroy, :show]

  def show
    @card_details = @current_user.card_detail
    render json: @card_details, status: :ok
  end

  def create
    @card_detail = @current_user.build_card_detail(process_card_detail_params)
    if @card_detail.save
      render json: @card_detail, status: :created
    else
      render json: { errors: @card_detail.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @card_detail.update(card_detail_params)
      render json: @card_detail, status: :ok
    else
      render json: { errors: @card_detail.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @card_detail.destroy
    render json: { message: 'Card details deleted successfully' }, status: :ok
  end

  private

  def find_card_detail
    @card_detail = @current_user.card_detail
  end

  def card_detail_params
    params.require(:card_detail).permit(:holder_name, :card_number, :expiry_date, :cvv, :card_type)
  end

  def process_card_detail_params
    params = card_detail_params
    if params[:expiry_date].present?
      parsed_date = Date.strptime(params[:expiry_date], '%m/%y') rescue nil
      if parsed_date
        params[:expiry_date] = parsed_date.strftime('%m/%y')
      else
        params[:expiry_date] = nil 
      end
    end
    params
  end
end
