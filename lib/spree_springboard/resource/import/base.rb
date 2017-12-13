module SpreeSpringboard
  module Resource
    module Import
      class Base < SpreeSpringboard::Resource::Base
        class_attribute :spree_class

        #
        # Perform import from Springboard of items from last day
        #
        def import_last_day
          return false if spree_class.nil?

          springboard_resources = client_query_last_day.get.body.results
          import_springboard_resources(springboard_resources)
        rescue StandardError => error
          ExceptionNotifier.notify_exception(error, data: { msg: "Import Last Day" })
        end

        #
        # Import Spree Elements from Springboard Resources
        #
        def import_springboard_resources(springboard_resources)
          springboard_resources.each do |springboard_resource|
            begin
              if find_spree_resource(springboard_resource).blank?
                create_from_springboard_resource(springboard_resource)
              end
            rescue StandardError => error
              ExceptionNotifier.notify_exception(error, exception_report_params(springboard_resource))
            end
          end
        end

        def create_from_springboard_resource(_springboard_resource)
          raise "Implement create_from_springboard_resource method for each resource"
        end

        def exception_report_params(springboard_resource)
          {
            data: {
              msg: "Import #{spree_class.name.demodulize.titleize.pluralize}",
              springboard_resource: springboard_resource
            }
          }
        end

        def find_spree_resource(springboard_resource)
          spree_class.find_springboard_synced(springboard_resource[:id])
        end
      end
    end
  end
end
