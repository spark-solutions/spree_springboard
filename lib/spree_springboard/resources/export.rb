module SpreeSpringboard
  module Resources
    class Export
      attr_reader :errors

      def client(_resource)
        raise 'Implement `client` for each reasource before using'
      end

      def export_new
        raise 'Implement `export_new` for each reasource before using'
      end

      def export_collection(klass)
        # TODO filter not sent
        klass.all.last(1)
      end

      def export_one(resource)
        response = client(resource).post(export_params_resource(resource))
        binding.pry
        if response && response.success?
          springboard_resource = response.resource.get
          spree_springboard_resource = Spree::SpringboardResource.new(
            resource: resource,
            springboard_id: springboard_resource[:id]
          )
          resource.springboard_resource = spree_springboard_resource
          resource.save

          springboard_resource[:id]
        end

        false
      end

      def self.export_one_for_parent(client_string, resource_type, resource_export_params, parent)
        custom_client = SpreeSpringboard.client[client_string]
        response = custom_client.post(resource_export_params)
        if response && response.success?
          springboard_resource = response.resource.get
          spree_springboard_resource = Spree::SpringboardResource.new(
            resource_type: resource_type,
            parent: parent,
            springboard_id: springboard_resource[:id]
          )
          parent.child_springboard_resources << spree_springboard_resource
          parent.save

          springboard_resource[:id]
        end

        false
      end

      def export_params_resource(resource)
        export_params_base(resource).
          merge!(export_params(resource))
      end

      def export_params(_resource)
        {}
      end

      def initialize
        @errors = []
      end

      private

      def export_params_base(_resource)
        {
          # id: resource.springboard_id
        }
      end

      def initialize_client
        raise 'Implement `initialize_client` for each reasource'
      end

      def perform_export_new(klass)
        export_collection(klass).each do |resource|
          export_one resource
        end
      end
    end
  end
end
