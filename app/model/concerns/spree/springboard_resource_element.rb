module Spree
  module SpringboardResourceElement
    extend ActiveSupport::Concern
    included do
      has_one :springboard_resource, as: :resource
      has_many :child_springboard_resources, class_name: 'Spree::SpringboardResource', as: :parent

      class_attribute :springboard_export_class

      def springboard_id
        springboard_resource.springboard_id if springboard_resource
      end

      def prepare_springboard_id
        if springboard_resource ||
           springboard_export_class.new.export_one(self) != false
          springboard_resource.springboard_id
        end
      end

      def child_springboard_id(child_type)
        child = child_springboard_resources.find { |element| element.resource_type == child_type }
        if child.present?
          child.springboard_id
        end
      end
    end
  end
end
