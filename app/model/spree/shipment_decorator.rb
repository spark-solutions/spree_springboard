module Spree
  Shipment.class_eval do
    state_machine do
      after_transition to: :shipped, do: :springboard_after_ship
    end

    def springboard_after_ship
      SpreeSpringboard::InvoiceOrderJob.perform_later(order)
    end
  end
end
