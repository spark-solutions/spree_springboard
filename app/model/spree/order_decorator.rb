module Spree
  Order.class_eval do
    include SpringboardResources
    include SpringboardResourceParent
    self.springboard_export_class = SpreeSpringboard::Resource::Order

    scope :springboard_invoiced, -> {
      left_joins(:child_springboard_resources) { where(resource_type: :invoice) }.
        where.not(child_springboard_resources_spree_orders: { springboard_id: nil }).
        uniq
    }

    scope :springboard_not_invoiced, -> {
      left_joins(:child_springboard_resources) { where(resource_type: :invoice) }.
        where(child_springboard_resources_spree_orders: { springboard_id: nil }).
        uniq
    }

    scope :springboard_ready_for_invoice, -> {
      springboard_synced.
        left_joins(:child_springboard_resources) { where(resource_type: :invoice) }.
        where(shipment_state: :shipped,
              child_springboard_resources_spree_orders: { springboard_id: nil }).
        uniq
    }

    def desync_springboard_before
      payments.springboard_synced.each(&:desync_springboard)
      line_items.springboard_synced.each(&:desync_springboard)
      child_springboard_resources.each(&:destroy)
    end

    def springboard_invoice!
      springboard_export_class.new.springboard_invoice!(self)
    end
  end
end
