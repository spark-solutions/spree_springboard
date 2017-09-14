module SpreeSpringboard
  module GiftCard
    def springboard_create
      response = create_gift_card
      return unless response.success?
      gift_card_response = springboard_gift_card
      return unless gift_card_response.success?
      gift_card = gift_card_response.body
      self.springboard_id = gift_card.id
      self.active = true
      save
    end

    def springboard_balance
      gift_card_response = springboard_gift_card
      return unless gift_card_response.success?
      gift_card_response.body.balance
    end

    def springboard_adjust_balance
      springboard_card_balance = springboard_balance
      return unless springboard_card_balance != amount_remaining
      adjust_balance(springboard_card_balance)
    end

    private

    def springboard_gift_card
      SpreeSpringboard.client[:gift_cards][code].get
    end

    def springboard_adjustment_reasons
      SpreeSpringboard.client[:reason_codes][:gift_card_adjustment_reasons].get
    end

    def first_reason
      reasons = springboard_adjustment_reasons
      return unless reasons.success?
      reasons.body.results.select { |key| key[:name] == 'Import' }.first.id
    end

    def create_gift_card
      SpreeSpringboard.client[:gift_cards].post(
        number: code,
        balance: amount_remaining,
        reason_id: first_reason
      )
    end

    def adjust_balance(springboard_balance)
      value = amount_remaining - springboard_balance
      SpreeSpringboard.client[:gift_card][:adjustments].post(
        gift_card_id: springboard_id,
        reason_id: first_reason,
        delta_balance: value
      )
    end
  end
end
