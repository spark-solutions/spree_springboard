Spree::PaymentMethod::GiftCard.class_eval do
  # Used in spree_gift_card gem
  def sync_integrated_gift_card(gift_card)
    gift_card.spree_adjust_balance!
  end
end
