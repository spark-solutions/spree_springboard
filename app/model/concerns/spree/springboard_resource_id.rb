module Spree
  module SpringboardResourceId
    extend ActiveSupport::Concern
    included do
      def set_springboard_id(springboard_resource_id)
        # Find existing SpringboardResource
        spree_springboard_resource = Spree::SpringboardResource.find_by(resource: self)
        if spree_springboard_resource.present?
          spree_springboard_resource.update(springboard_id: springboard_resource_id)
        else
          spree_springboard_resource = Spree::SpringboardResource.new(
            resource: self, springboard_id: springboard_resource_id
          )
          spree_springboard_resource.save
        end

        if spree_springboard_resource.springboard_id != springboard_resource_id
          # Update springboard_resource_id if needed
          spree_springboard_resource.update(springboard_id: springboard_resource_id)
          self.springboard_resource = spree_springboard_resource
          save
        end
      end

      def springboard_id
        # Getter
        springboard_resource.springboard_id if springboard_resource
      end

      def prepare_springboard_id
        # Use saved springboard_id or synchronize
        springboard_id if springboard_resource || springboard_sync! != false
      end
    end
  end
end
