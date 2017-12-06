module SpreeSpringboard
  class ExportNewOrdersJob < ApplicationJob
    queue_as :default

    def perform(*_args)
      # TODO adjust
      Spree::Order.springboard_not_synced.each(&:sync_springboard)
    end
  end
end
