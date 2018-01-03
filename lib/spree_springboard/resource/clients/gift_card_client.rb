module SpreeSpringboard::Resource::Clients
  module GiftCardClient
    def client(gift_card)
      gift_card.springboard_id ? client_resource(gift_card) : client_create(gift_card)
    end

    def client_resource(gift_card)
      SpreeSpringboard.client[:gift_cards][gift_card.code]
    end

    def client_create(_gift_card)
      SpreeSpringboard.client[:gift_cards]
    end
  end
end
