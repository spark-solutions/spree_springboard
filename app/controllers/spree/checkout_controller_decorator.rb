Spree::CheckoutController.class_eval do
  before_action :prepare_gift_card_payment_method, only: :edit

  private

  # Method used in spree_gift_card gem
  def import_integrated_gift_card
    code = params[:payment_source][gift_card_payment_method.try(:id).to_s][:code]
    spree_gift_card = Spree::GiftCard.springboard_import_by_code(code)

    spree_gift_card.present? ? spree_gift_card : false
  end

  # Update gift cards' balance before showing payment state
  def prepare_gift_card_payment_method
    if @order.state == 'payment' && spree_current_user.present?
      Spree::GiftCard.springboard_import_gift_cards_balance(spree_current_user.gift_cards)
    end
  end

  # Method used in spree_gift_card gem
  def sync_integrated_gift_card(gift_card)
    gift_card.spree_adjust_balance!
  end
end
