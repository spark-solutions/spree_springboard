module SpreeSpringboard
  class ExportOrderJob < ApplicationJob
    queue_as :default

    def perform(order)
      if order.springboard_id.blank?
        order.sync_springboard
      end
    end
  end
end
