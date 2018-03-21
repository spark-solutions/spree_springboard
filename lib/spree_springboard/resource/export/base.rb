module SpreeSpringboard
  module Resource
    module Export
      class Base < SpreeSpringboard::Resource::Base
        def after_sync(_resource); end

        def export_params(_resource, _params = {})
          {}
        end

        def fetch(resource)
          response = client_resource(resource).get
          response.body if response && response.success?
        end

        def update(resource, params)
          Spree::SpringboardLog.notice("Update attempt #{params}", resource)
          response = client_resource(resource).put(params)
          result = response && response.success?
          Spree::SpringboardLog.notice("Update result #{result}", resource)
          result
        end

        def sync_request(resource, params)
          client(resource).
            send(sync_method(resource), export_params(resource, params))
        end

        def sync!(resource, params = {})
          Spree::SpringboardLog.notice('Sync Start', resource)
          # Export one resource to Springboard
          # Can be used as update as well
          response = sync_request(resource, params)
          if response && response.success?
            if response.resource
              # if sync_method == post and successful then update springboard_id
              # sync_method == post doesn't return resource
              springboard_resource = response.resource.get
              resource.springboard_id = springboard_resource[:id]
              Spree::SpringboardLog.notice("Springboard ID #{springboard_resource[:id]}", resource)
              resource.reload
            end

            after_sync(resource)
            resource.springboard_element(true)
            Spree::SpringboardLog.success('Sync OK', resource)
            resource.springboard_id
          else
            if response
              Spree::SpringboardLog.notice("Response status #{response.status}", resource)
              Spree::SpringboardLog.notice("Response body #{response.body}", resource)
            end
            Spree::SpringboardLog.error('Sync Fail', resource)
            false
          end
        end

        def sync_method(resource)
          resource.springboard_id ? :put : :post
        end

        def self.sync_parent!(client_string, resource_type, resource_export_params, parent)
          # Export one resource to Springboard
          # Resource will be linked to a parent object
          # Example:
          # - customer or address for guest order
          # - invoice for order
          log_params = { resource_type: resource_type, parent: parent }
          Spree::SpringboardLog.notice('Sync Start', nil, log_params)
          custom_client = SpreeSpringboard.client[client_string]
          response = custom_client.post(resource_export_params)
          if response && response.success?
            if !response.resource.nil? && response.resource.exists?
              springboard_resource = response.resource.get
              parent.set_child_springboard_id(resource_type, springboard_resource[:id])

              Spree::SpringboardLog.notice("Sync OK, Springboard ID #{springboard_resource[:id]}", nil, log_params)
              return springboard_resource[:id]
            end
            Spree::SpringboardLog.success('Sync OK', nil, log_params)
            true
          else
            if response
              Spree::SpringboardLog.notice("Response status #{response.status}", nil, log_params)
              Spree::SpringboardLog.notice("Response body #{response.body}", nil, log_params)
            end
            Spree::SpringboardLog.error('Sync Fail', nil, log_params)
            false
          end
        end
      end
    end
  end
end
