Spree::UserGiftCardsController.class_eval do
  before_action :springboard_import_gift_cards_balance, only: :edit

  private

  def springboard_import_gift_cards_balance
    if @order.state == :payment && @order.user.present?
      @order.user.springboard_import_gift_cards_balance
    end
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
