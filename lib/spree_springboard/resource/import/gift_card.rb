module SpreeSpringboard
  module Resource
    module Import
      class GiftCard < SpreeSpringboard::Resource::Import::Base
        include SpreeSpringboard::Resource::Clients::GiftCardClient
        self.spree_class = Spree::GiftCard

        class << self
          def import_from_springboard_by_code(code)
            return if code.blank?
            result = SpreeSpringboard.client[:gift_cards][code].get
            return unless result && result.success?
            springboard_gift_card = result.body
            return false if springboard_gift_card.blank?

            create_from_springboard_resource(springboard_gift_card)
          end

          def create_from_springboard_resource(springboard_resource)
            variant = Spree::Product.not_deleted.gift_cards.first.master
            Spree::GiftCard.create!(
              code: springboard_resource.number,
              current_value: springboard_resource.balance,
              original_value: springboard_resource.balance,
              variant: variant
            )
          end
        end
      end
    end
  end
end
