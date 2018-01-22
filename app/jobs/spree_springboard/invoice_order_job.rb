module SpreeSpringboard
  class InvoiceOrderJob < ApplicationJob
    queue_as :springboard

    def perform(order)
      if order.shipments.all?(&:shipped?)
        order.springboard_export! if order.springboard_id.nil?
        order.springboard_invoice!
      end
    rescue StandardError => error
      ExceptionNotifier.notify_exception(error, data: { msg: "Order #{order.number}" })
      raise error
    end
  end
end
