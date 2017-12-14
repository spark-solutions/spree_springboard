module Spree
  module SpringboardResourceExport
    extend ActiveSupport::Concern
    included do
      class_attribute :springboard_export_class

      def springboard_export!
        return false unless springboard_export_class.present?

        # Perform export to springboard
        export_manager = springboard_export_class.new
        sync_result = export_manager.sync!(self) != false
        reload
        sync_result
      end
    end
  end
end
