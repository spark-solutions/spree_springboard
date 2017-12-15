module SpreeSpringboard
  class ExportOrderJob < ApplicationJob
    queue_as :default

    def perform(order)
      order.springboard_export! if order.springboard_id.blank?
    rescue StandardError => error
      ExceptionNotifier.notify_exception(error, data: { msg: "Order #{order.number}" })
      raise error
    end
  end
end
