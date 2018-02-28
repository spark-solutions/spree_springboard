module Spree
  Order.class_eval do
    include SpringboardResources
    include SpringboardResourceParent
    self.springboard_export_class = SpreeSpringboard::Resource::Export::Order

    state_machine do
      after_transition to: :complete, do: :schedule_springboard_export
      before_transition to: :complete, do: :update_gift_cards_balance
    end

    # Schedule order and purchased e-gift-cards export to Springboard
    def schedule_springboard_export
      SpreeSpringboard::ExportOrderJob.perform_later(self)
      line_items.
        select(&:is_e_gift_card?).
        map(&:gift_card).
        each(&:schedule_springboard_export)
    end

    # Clean child springboard resources before desync action
    def springboard_desync_before
      return_authorizations.springboard_synced.each(&:springboard_desync!)
      payments.springboard_synced.each(&:springboard_desync!)
      line_items.springboard_synced.each(&:springboard_desync!)
      child_springboard_resources.each(&:destroy)
    end

    # Create invoice in springboard
    def springboard_invoice!
      springboard_export_class.new.springboard_invoice!(self)
    end

    # Update the balance of the used GiftCards before order completion
    def update_gift_cards_balance
      gift_cards = payments.gift_cards.where(state: :checkout).map(&:source).compact.uniq
      Spree::GiftCard.springboard_import_gift_cards_balance(gift_cards)
    end
  end
end
