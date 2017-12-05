module Spree
  module SpringboardResourceParent
    extend ActiveSupport::Concern
    included do
      has_many :child_springboard_resources, class_name: 'Spree::SpringboardResource', as: :parent

      def child_springboard_id(child_type)
        # Getter
        child = child_springboard_resources.find { |element| element.resource_type == child_type }
        if child.present?
          child.springboard_id
        end
      end

      def set_child_springboard_id(child_type, springboard_resource_id)
        # Setter
        child = child_springboard_resources.find { |element| element.resource_type == child_type }
        if child.present?
          child.update(springboard_id: springboard_resource_id)
        else
          spree_springboard_resource = Spree::SpringboardResource.new(
            resource_type: child_type,
            parent: self,
            springboard_id: springboard_resource_id
          )
          child_springboard_resources << spree_springboard_resource
          save
        end
      end
    end
  end
end
