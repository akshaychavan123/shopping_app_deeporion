class Api::V2::GiftCardsController < ApplicationController
  before_action :authorize_request
  before_action :set_gift_card, only: [:show, :update, :destroy]

  def index
    @gift_cards = GiftCard.all
    render json: @gift_cards
  end

  def show
    render json: @gift_card
  end

  def create
    @gift_card = GiftCard.new(gift_card_params)

    if @gift_card.save
      render json: @gift_card, status: :created
    else
      render json: @gift_card.errors, status: :unprocessable_entity
    end
  end

  def update
    if @gift_card.update(gift_card_params)
      render json: @gift_card
    else
      render json: @gift_card.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @gift_card.destroy
    head :no_content
  end

  private

  def set_gift_card
    @gift_card = GiftCard.find(params[:id])
  end

  def gift_card_params
    params.require(:gift_card).permit(:image, :price, :gift_card_category_id)
  end
end
  