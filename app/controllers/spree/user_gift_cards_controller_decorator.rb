Spree::UserGiftCardsController.class_eval do
  before_action :springboard_import_gift_cards_balance, only: :index

  private

  def springboard_import_gift_cards_balance
    spree_current_user.springboard_import_gift_cards_balance
  end

  def import_integrated_gift_card
    spree_gift_card = Spree::GiftCard.springboard_import_by_code(params[:code])
    if spree_gift_card.present?
      spree_current_user.gift_cards << spree_gift_card
      flash[:success] = 'Gift Card added'
      return true
    end
    false
  end
end
