module SpreeSpringboard
  class InvoiceOrderJob < ApplicationJob
    queue_as :default

    def perform(order)
      if order.shipments.all?(&:shipped?)
        if order.springboard_id.nil?
          order.sync_springboard
        end
        order.springboard_invoice!
      end
    end
  end
end
