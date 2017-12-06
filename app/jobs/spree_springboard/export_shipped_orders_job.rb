module SpreeSpringboard
  class ExportShippedOrdersJob < ApplicationJob
    queue_as :default

    def perform(*_args)
      # TODO adjust
      Spree::Order.springboard_synced.where(shipment_state: :shipped).each(&:springboard_invoice!)
    end
  end
end
