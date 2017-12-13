module SpreeSpringboard
  module Resource
    module Import
      class CustomerReturn < SpreeSpringboard::Resource::Import::Base
        include SpreeSpringboard::Resource::Clients::CustomerReturnClient
        self.spree_class = Spree::CustomerReturn

        def create_from_springboard_resource(springboard_return)
          return unless springboard_return[:id] == 137506
          invoice_resource = find_spree_invoice(springboard_return)
          raise "Invoice #{springboard_return[:id]} missing in Spree" if invoice_resource.blank?

          order = invoice_resource.parent
          return_authorization = create_spree_return_authorization(order, springboard_return)
          return_items = load_return_items(return_authorization)

          return_lines = springboard_return_lines(springboard_resource)
          items = return_lines.map do |line|
            {
              springboard_id: line[:item_id],
              qty: line[:qty],
            }
          end
        end

        def find_spree_invoice(springboard_resource)
          Spree::SpringboardResource.find_by(
            resource_type: 'invoice',
            springboard_id: springboard_resource[:parent_transaction_id]
          )
        end

        def springboard_return_lines(springboard_return)
          SpreeSpringboard.client["sales/tickets/#{springboard_return[:id]}/lines"].get.body.results
        end

        def load_return_items(return_authorization)
          all_inventory_units = return_authorization.order.inventory_units
          associated_inventory_units = return_authorization.return_items.map(&:inventory_unit)
          unassociated_inventory_units = all_inventory_units - associated_inventory_units

          unassociated_inventory_units.map do |new_unit|
            Spree::ReturnItem.new(inventory_unit: new_unit).tap(&:set_default_pre_tax_amount)
          end
        end

        def create_spree_return_authorization(order, springboard_return)
          Spree::ReturnAuthorization.create!(
            order: order,
            stock_location: Spree::StockLocation.first,
            return_authorization_reason: Spree::ReturnAuthorizationReason.active.first,
            memo: "Springboard Return ##{springboard_return[:id]}"
          )
        end
      end
    end
  end
end
