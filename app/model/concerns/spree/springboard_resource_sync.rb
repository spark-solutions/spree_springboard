module Spree
  module SpringboardResourceSync
    extend ActiveSupport::Concern
    included do
      scope :springboard_synced, -> {
        left_joins(:springboard_resource).where('spree_springboard_resources.springboard_id IS NOT NULL')
      }
      scope :springboard_not_synced, -> {
        left_joins(:springboard_resource).where('spree_springboard_resources.springboard_id IS NULL')
      }

      def desync_springboard_after; end

      def desync_springboard_before; end

      def desync_springboard
        desync_springboard_before
        if springboard_resource
          springboard_resource.destroy
        end
        desync_springboard_after
        reload
      end

      def springboard_element(reload = false)
        if reload
          @springboard_element = springboard_export_class.new.fetch(self)
        end
        @springboard_element ||= springboard_export_class.new.fetch(self)
      end

      def sync_springboard
        # Perform synchronization
        export_manager = springboard_export_class.new
        sync_result = export_manager.sync(self) != false
        reload
        sync_result
      end
    end
  end
end
