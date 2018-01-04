module Spree
  module SpringboardResourceSync
    extend ActiveSupport::Concern
    included do
      scope :springboard_synced, lambda {
        left_joins(:springboard_resource).where('spree_springboard_resources.springboard_id IS NOT NULL')
      }
      scope :springboard_not_synced, lambda {
        left_joins(:springboard_resource).where('spree_springboard_resources.springboard_id IS NULL')
      }

      def self.find_springboard_synced(springboard_id)
        left_joins(:springboard_resource).
          find_by('spree_springboard_resources.springboard_id = ?', springboard_id)
      end

      def springboard_desync_after; end

      def springboard_desync_before; end

      def springboard_desync!
        springboard_desync_before
        springboard_resource.destroy if springboard_resource
        springboard_desync_after
        reload
      end

      # Fetch a Springboard element related to the Spree object (ie. order.springboard_element)
      def springboard_element(reload = false)
        @springboard_element = springboard_export_class.new.fetch(self) if reload
        @springboard_element ||= springboard_export_class.new.fetch(self)
      end
    end
  end
end
