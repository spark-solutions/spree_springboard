module SpreeSpringboard
  module Resource
    class Order < SpreeSpringboard::Resource::Base
      include SpreeSpringboard::Resource::Clients::OrderClient

      def after_sync(order)
        # Create or Update line items
        order.line_items.each(&:sync_springboard)

        # Create Taxes (reset taxes first if needed)
        check_tax_sync(order)
        spree_taxes(order).springboard_not_synced.each(&:sync_springboard)

        # Create payments
        order.payments.springboard_not_synced.each(&:sync_springboard)

        # Open order if possible
        springboard_open!(order)
      end

      def calculate_springboard_tax_total(order)
        result = SpreeSpringboard.client["sales/orders/#{order.springboard_id}/taxes"].query(per_page: 1000).get
        raise "Springboard Order #{order_springboard_id} missing" unless result && result.success?
        result.body.results.map(&:value).sum
      end

      def check_tax_sync(order)
        # Create Taxes (remove all first if needed)
        springboard_tax = calculate_springboard_tax_total(order)
        if springboard_tax > 0 && springboard_tax != spree_taxes(order).sum(:amount)
          # Remove tax sync data
          spree_taxes(order).each(&:desync_springboard)

          # Reset tax value in Springboard
          SpreeSpringboard.client["sales/orders/#{order.springboard_id}/taxes"].
            post(description: 'Tax reset', value: -springboard_tax)
        end
      end

      def export_params(order)
        # Sync user or create guest user in Springboard
        springboard_user_id = prepare_springboard_user_id(order)

        # Sync addresses for the above user
        billing_address_id = prepare_springboard_address_id(order, 'bill_address', springboard_user_id)
        shipping_address_id = prepare_springboard_address_id(order, 'ship_address', springboard_user_id)

        {
          customer_id: springboard_user_id,
          billing_address_id: billing_address_id,
          shipping_address_id: shipping_address_id,
          shipping_charge: shipping_total(order),
          shipping_method_id: 100001,
          status: 'pending',
          sales_rep: order.number,
          source_location_id: SpreeSpringboard.configuration.source_location_id,
          station_id: SpreeSpringboard.configuration.station_id,
          created_at: order.created_at,
          updated_at: order.updated_at
        }
      end

      def shipping_total(order)
        adjustments = order.shipments.map(&:adjustments).flatten
        order.ship_total + adjustments.sum(&:amount)
      end

      def spree_taxes(order)
        order.adjustments.eligible.tax
      end

      def springboard_open!(order)
        if order.paid? && order.springboard_element[:status] == 'pending'
          update(order, status: 'open')
        end
      end

      def springboard_can_invoice?(order)
        order.shipped? &&
          !springboard_invoiced(order) &&
          order.springboard_element[:status] == 'open'
      end

      def springboard_invoice!(order)
        if springboard_can_invoice?(order)
          invoice_springboard_id = springboard_invoice_create!(order)
          if invoice_springboard_id.present?
            springboard_invoice_line_items_create!(order, invoice_springboard_id)
          end

          invoice_springboard_id
        end
      end

      # returns invoice_springboard_id
      def springboard_invoice_create!(order)
        SpreeSpringboard::Resource::Base.
          sync_parent("api/sales/invoices",
                      'invoice',
                      springboard_invoice_params(order),
                      order)
      end

      def springboard_invoice_complete!(order)
        endpoint = "api/sales/invoices/#{order.child_springboard_id('invoice')}"
        client = SpreeSpringboard.client[endpoint]
        response = client.put(status: 'complete')

        response && response.success?
      end

      def springboard_invoice_line_items_create!(order, invoice_springboard_id)
        invoice_lines_endpoint = "api/sales/invoices/#{invoice_springboard_id}/lines"
        order.line_items.each do |line_item|
          SpreeSpringboard::Resource::Base.
            sync_parent(invoice_lines_endpoint,
                        'invoice_line',
                        springboard_invoice_line_params(line_item),
                        order)
        end

        invoice_lines_client = SpreeSpringboard.client[invoice_lines_endpoint]
        resources = invoice_lines_client.get
        if resources
          resources.body.results.each do |result|
            order.set_child_springboard_id('invoice_line', result[:id])
          end
        end
      end

      def springboard_invoice_params(order)
        {
          customer_id: order.prepare_springboard_id,
          order_id: order.springboard_id,
          station_id: SpreeSpringboard.configuration.station_id,
          total: order.total
        }
      end

      def springboard_invoice_line_params(line_item)
        {
          type: "ItemLine",
          qty: line_item.springboard_element[:qty],
          item_id: line_item.springboard_element[:item_id]
        }
      end

      def springboard_invoiced(order)
        order.child_springboard_id('invoice').present?
      end

      private

      def prepare_springboard_address_id(order, address_type, springboard_user_id)
        address = order.send(address_type)
        if order.user
          # Sync Spree address. If order.user exists, then address includes user_id
          address.prepare_springboard_id
        else
          # Check if guest address has already been synced
          springboard_id = order.child_springboard_id(address_type)
          return springboard_id if springboard_id.present?

          # Sync guest address if needed
          params = SpreeSpringboard::Resource::Address.new.export_params(address)
          SpreeSpringboard::Resource::Base.sync_parent(
            "customers/#{springboard_user_id}/addresses", address_type, params, order
          )
        end
      end

      def prepare_springboard_user_id(order)
        if order.user
          # Sync Spree user
          order.user.prepare_springboard_id
        else
          # Check if guest user has already been synced
          springboard_id = order.child_springboard_id('user')
          return springboard_id if springboard_id.present?

          # Sync guest user if needed
          params = {
            first_name: order.bill_address.first_name,
            last_name: order.bill_address.last_name,
            email: order.email
          }
          SpreeSpringboard::Resource::Base.sync_parent(
            :customers, :user, params, order
          )
        end
      end
    end
  end
end
