class Api::V2::GiftCardsController < ApplicationController
  before_action :authorize_request
  before_action :check_user
  before_action :set_gift_card, only: [:show, :update, :destroy]

  def index
    @gift_cards = GiftCard.all
    render json: { data: ActiveModelSerializers::SerializableResource.new(@gift_cards, each_serializer: GiftCardSerializer)}
  end

  def show
    render json: { data: ActiveModelSerializers::SerializableResource.new(@gift_card, each_serializer: GiftCardSerializer)}
  end

  def create
    @gift_card = GiftCard.new(gift_card_params)

    if params[:images].present?
      Array(params[:images]).each do |image|
        @gift_card.images.attach(image)
      end
    end

    if @gift_card.save
      render json: { data: ActiveModelSerializers::SerializableResource.new(@gift_card, each_serializer: GiftCardSerializer)}, status: :created
    else
      render json: @gift_card.errors, status: :unprocessable_entity
    end
  end

  def update  
    if params[:images].present?
      @gift_card.images.attachments.each(&:purge) if params[:replace_images] == 'true'
      Array(params[:images]).each do |image|
        @gift_card.images.attach(image)
      end
    end
  
    if @gift_card.update(gift_card_params)
      render json: { data: ActiveModelSerializers::SerializableResource.new(@gift_card, each_serializer: GiftCardSerializer) }
    else
      render json: @gift_card.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @gift_card.destroy
      render json: { message: 'GiftCard successfully deleted' }, status: :ok
    else
      render json: { error: 'Failed to delete GiftCard' }, status: :unprocessable_entity
    end
  end
  

  private

  def set_gift_card
    @gift_card = GiftCard.find(params[:id])
  end

  def gift_card_params
    params.permit(:gift_card_category_id, :price)
  end

  def check_user
    unless @current_user.type == "Admin"
      render json: { errors: ['Unauthorized access'] }, status: :forbidden
    end
  end
end
