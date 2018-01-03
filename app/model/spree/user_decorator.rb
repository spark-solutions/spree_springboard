module Spree
  User.class_eval do
    include SpringboardResources
    self.springboard_export_class = SpreeSpringboard::Resource::Export::User

    def springboard_import_gift_cards_balance
      springboard_gift_card_numbers = gift_cards.map { |g| g.code.upcase }
      return true if springboard_gift_card_numbers.empty?

      result = SpreeSpringboard.
               client[:gift_cards].
               query(_filter: { number: { '$in' => springboard_gift_card_numbers } }).
               get
      return false unless result && result.success?

      result.body.results.each do |springboard_gift_card|
        gift_card = gift_cards.find { |g| g.code.upcase == springboard_gift_card.number }
        next if gift_card.blank?

        delta = gift_card.current_value - springboard_gift_card.balance
        next if delta.zero?
        Spree::GiftCardTransaction.create!(
          gift_card: gift_card,
          amount: delta
        )

        # Skip after update commit for GiftCard
        gift_card.update_column(:current_value, springboard_gift_card.balance)
      end
      true
    end
  end
end
