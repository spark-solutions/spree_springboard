module Spree
  Order.class_eval do
    include SpringboardResources
    include SpringboardResourceParent
    self.springboard_export_class = SpreeSpringboard::Resource::Order

    state_machine do
      after_transition to: :complete, do: :springboard_after_complete
    end

    def springboard_desync_before
      payments.springboard_synced.each(&:springboard_desync!)
      line_items.springboard_synced.each(&:springboard_desync!)
      child_springboard_resources.each(&:destroy)
    end

    def springboard_after_complete
      SpreeSpringboard::ExportOrderJob.perform_later(self)
    end

    def springboard_invoice!
      springboard_export_class.new.springboard_invoice!(self)
    end
  end
end
