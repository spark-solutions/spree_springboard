module SpreeSpringboard
  class InvoiceOrderJob < ApplicationJob
    queue_as :default

    def perform(order)
      if order.shipments.all?(&:shipped?)
        if order.springboard_id.nil?
          order.springboard_export!
        end
        order.springboard_invoice!
      end
    rescue StandardError => error
      ExceptionNotifier.notify_exception(error, data: { msg: "Order #{order.number}" })
      raise error
    end
  end
end
