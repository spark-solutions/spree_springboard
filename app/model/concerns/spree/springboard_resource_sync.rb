module Spree
  module SpringboardResourceSync
    extend ActiveSupport::Concern
    included do
      scope :springboard_synced, -> {
        left_joins(:springboard_resource).
          where('spree_springboard_resources.springboard_id IS NOT NULL').uniq
      }
      scope :springboard_not_synced, -> {
        left_joins(:springboard_resource).
          where('spree_springboard_resources.springboard_id IS NULL').uniq
      }

      def desync_springboard_after; end

      def desync_springboard_before; end

      def desync_springboard
        desync_springboard_before
        if springboard_resource
          springboard_resource.destroy
          reload
        end
        desync_springboard_after
      end

      def sync_springboard
        # Perform synchronization
        export_manager = springboard_export_class.new
        export_manager.sync(self) != false
      end
    end
  end
end
