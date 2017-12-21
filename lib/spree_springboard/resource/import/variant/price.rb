module SpreeSpringboard
  module Resource
    module Import
      class Variant < SpreeSpringboard::Resource::Import::Base
        #
        # Variant price update methods
        #
        module Price
          def import_prices!
            page_count = springboard_page_count(client_query)
            page_count.downto(1).each do |page_no|
              begin
                import_prices_page(client_query, page_no)
              rescue StandardError => error
                log(error, data: { page_no: page_no })
                next
              end
            end

            true
          end

          #
          # Price Import - fetch a page by page number and update all the items
          #
          def import_prices_page(import_client, page_no)
            response = import_client.query(per_page: PER_PAGE, page: page_no).get
            raise 'Import Prices Page Error - Response not successful' unless response.success?

            response.body.results.each do |springboard_item|
              begin
                import_prices_from_springboard_resource(springboard_item)
              rescue StandardError => error
                log(error, data: { springboard_item: springboard_item })
                next
              end
            end
          end

          #
          # Price Import - update one fetched item
          #
          def import_prices_from_springboard_resource(springboard_item)
            variant = Spree::Variant.find_by_springboard_id(springboard_item.id)
            return if variant.blank?

            values = {
              cost_price: (springboard_item.cost if springboard_item.cost != variant.cost_price),
              price: (springboard_item.price if springboard_item.price != variant.price),
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
