module SpreeSpringboard
  class ExportOrderJob < ApplicationJob
    queue_as :default

    def perform(order)
      if order.springboard_id.blank?
        order.springboard_sync!
      end
    rescue StandardError => error
      ExceptionNotifier.notify_exception(error, data: { msg: "Order #{order.number}" })
      raise error
    end
  end
end
