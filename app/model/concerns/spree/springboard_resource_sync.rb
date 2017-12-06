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

      def springboard_desync_after; end

      def springboard_desync_before; end

      def springboard_desync!
        springboard_desync_before
        if springboard_resource
          springboard_resource.destroy
        end
        springboard_desync_after
        reload
      end

      def springboard_element(reload = false)
        @springboard_element = springboard_export_class.new.fetch(self) if reload
        @springboard_element ||= springboard_export_class.new.fetch(self)
      end

      def springboard_sync!
        # Perform synchronization
        export_manager = springboard_export_class.new
        sync_result = export_manager.sync(self) != false
        reload
        sync_result
      end
    end
  end
end
