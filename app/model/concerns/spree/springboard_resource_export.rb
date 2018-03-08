module Spree
  module SpringboardResourceExport
    extend ActiveSupport::Concern
    included do
      class_attribute :springboard_export_class

      def can_springboard_export?
        true
      end

      def springboard_export!(params = {})
        return false unless springboard_export_class.present? && can_springboard_export?

        # Perform export to springboard
        export_manager = springboard_export_class.new
        sync_result = export_manager.sync!(self, params) != false
        reload
        sync_result
      end
    end
  end
end
