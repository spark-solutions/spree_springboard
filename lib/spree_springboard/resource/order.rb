module SpreeSpringboard
  module Resource
    class Order < SpreeSpringboard::Resource::Base
      include SpreeSpringboard::Resource::Clients::OrderClient

      def after_sync(order)
        # Create or Update line items
        order.line_items.each(&:sync_springboard)

        # Create payments
        order.payments.springboard_not_synced.each(&:sync_springboard)

        # Create Taxes (reset taxes first if needed)
        check_tax_sync(order)
        order.adjustments.eligible.tax.springboard_not_synced.each(&:sync_springboard)

        # Create Discounts TODO
      end

      def calculate_springboard_tax_total(order)
        result = SpreeSpringboard.client["sales/orders/#{order.springboard_id}/taxes"].query(per_page: 1000).get
        raise "Springboard Order #{order_springboard_id} missing" unless result && result.success?
        result.body.results.map(&:value).sum
      end

      def check_tax_sync(order)
        # Create Taxes (remove all first if needed)
        spree_taxes = order.adjustments.eligible.tax
        springboard_tax = calculate_springboard_tax_total(order)
        if springboard_tax > 0 && springboard_tax != spree_taxes.sum(:amount)
          # Remove tax sync data
          spree_taxes.each(&:desync_springboard)

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
          shipping_charge: order.ship_total.to_f,
          shipping_method_id: 100001,
          status: 'pending',
          sales_rep: "",
          source_location_id: SpreeSpringboard.configuration.source_location_id,
          station_id: SpreeSpringboard.configuration.station_id,
          created_at: order.created_at,
          updated_at: order.updated_at
        }
      end

      private

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
    end
  end
end
