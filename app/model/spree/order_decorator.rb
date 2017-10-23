module Spree
  Order.class_eval do
    include SpringboardResources
    include SpringboardResourceParent
    self.springboard_export_class = SpreeSpringboard::Resource::Order

    def desync_springboard_before
      payments.springboard_synced.each(&:desync_springboard)
      line_items.springboard_synced.each(&:desync_springboard)
    end
  end
end
