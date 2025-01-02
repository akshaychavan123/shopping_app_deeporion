class GiftCardMailer < ApplicationMailer

  def send_gift_card(card_order)
    @card_order = card_order
    @gift_card = card_order.gift_card

    mail(
      to: @card_order.recipient_email,
      subject: "You've received a gift card!"
    )
  end
end
