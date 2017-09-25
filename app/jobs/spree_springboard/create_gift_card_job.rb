module SpreeSpringboard
  class CreateGiftCardJob < ApplicationJob
    queue_as :default

    def perform(*_args)
      Spree::GiftCard.inactive.where(springboard_id: nil).each(&:springboard_create)
    end
  end
end
