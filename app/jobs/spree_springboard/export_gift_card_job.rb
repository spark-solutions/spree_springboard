module SpreeSpringboard
  class ExportGiftCardJob < ApplicationJob
    queue_as :default

    def perform(gift_card)
      gift_card.springboard_export! if gift_card.springboard_id.blank?
    rescue StandardError => error
      ExceptionNotifier.notify_exception(error, data: { msg: "Export GiftCard #{gift_card.code}" })
      raise error
    end
  end
end
