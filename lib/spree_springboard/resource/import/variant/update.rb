module SpreeSpringboard
  module Resource
    module Import
      class Variant < SpreeSpringboard::Resource::Import::Base
        #
        # Variant update methods
        #
        module Update
          def import_attributes!
            page_count = springboard_page_count(client_query)
            page_count.downto(1).each do |page_no|
              begin
                import_attributes_page(client_query, page_no)
              rescue StandardError => error
                log(error, data: { page_no: page_no })
                next
              end
            end

            true
          end

          def import_attributes_page(import_client, page_no)
            response = import_client.query(per_page: PER_PAGE, page: page_no).get
            raise 'Import Attributes Page Error - Response not successful' unless response.success?

            response.body.results.each do |springboard_item|
              begin
                import_attributes_from_springboard_resource(springboard_item)
              rescue StandardError => error
                log(error, data: { springboard_item: springboard_item })
                next
              end
            end
          end

          def import_attributes_from_springboard_resource(springboard_item)
            variant = Spree::Variant.find_by_springboard_id(springboard_item.id)
            return if variant.blank?

            values = {
              cost_price: (springboard_item.cost if springboard_item.cost != variant.cost_price),
              original_price: (springboard_item.original_price if springboard_item.original_price != variant.original_price),
              sale_price: (springboard_item.price if springboard_item.price != variant.sale_price),
              upc: (springboard_item.custom.upc if springboard_item.custom.upc != variant.upc),
              weight: (springboard_item.weight if springboard_item.weight != variant.weight)
            }.compact

            if values.present?
              variant.update values
              return true
            end

            false
          end
        end
      end
    end
  end
end
