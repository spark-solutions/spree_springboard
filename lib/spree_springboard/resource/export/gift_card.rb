module SpreeSpringboard
  module Resource
    module Export
      class GiftCard < SpreeSpringboard::Resource::Export::Base
        include SpreeSpringboard::Resource::Clients::GiftCardClient

        def after_sync(gift_card)
          gift_card.update(active: true)
        end

        def export_params(gift_card, _params = {})
          {
            number: gift_card.code,
            balance: gift_card.amount_remaining,
            reason_id: self.class.gift_card_reason
          }
        end

        def self.adjust_balance(gift_card)
          raise 'No Springboard ID present' unless gift_card.springboard_id.present?

          springboard_balance = gift_card.springboard_element.balance
          return if springboard_balance == gift_card.amount_remaining

          result = SpreeSpringboard.client[:gift_card][:adjustments].post(
            gift_card_id: gift_card.springboard_id,
            reason_id: gift_card_reason,
            delta_balance: gift_card.amount_remaining - springboard_balance
          )

          result.present? && result.success?
        end

        def self.gift_card_reason
          reasons = SpreeSpringboard.client[:reason_codes][:gift_card_adjustment_reasons].get
          return unless reasons.success?
          reasons.body.results.select { |key| key[:name] == 'Import' }.first.id
        end
      end
    end
  end
end
