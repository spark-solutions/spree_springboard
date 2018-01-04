module SpreeSpringboard
  class UpdateGiftCardJob < ApplicationJob
    queue_as :default

    def perform(gift_card)
      gift_card.springboard_adjust_balance!
    rescue StandardError => error
      ExceptionNotifier.notify_exception(error, data: { msg: "Update GiftCard #{gift_card.code}" })
      raise error
    end
  end
end
