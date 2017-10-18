module SpreeSpringboard
  module Orders
    class Export < SpreeSpringboard::Resources::Export
      def client(order)
        order.springboard_id ? client_update(order) : client_create
      end

      def client_update(order)
        SpreeSpringboard.client["sales/orders/#{order.springboard_id}"]
      end

      def client_create
        SpreeSpringboard.client["sales/orders"]
      end

      def export_new
        perform_export_new(Spree::Order)
      end

      def export_params(order)
        springboard_user_id = prepare_springboard_user_id(order)
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
          order.user.prepare_springboard_id
        else
          springboard_id = order.child_springboard_id('user')
          return springboard_id if springboard_id.present?

          params = {
            first_name: order.bill_address.first_name,
            last_name: order.bill_address.last_name,
            email: order.email
          }
          SpreeSpringboard::Resources::Export.export_one_for_parent(
            :customers, :user, params, order
          )
        end
      end

      def prepare_springboard_address_id(order, address_type, springboard_user_id)
        address = order.send(address_type)
        if order.user
          address.prepare_springboard_id
        else
          springboard_id = order.child_springboard_id(address_type)
          return springboard_id if springboard_id.present?

          address_export_manager = SpreeSpringboard::Addresses::Export.new
          params = address_export_manager.export_params(address)

          SpreeSpringboard::Resources::Export.export_one_for_parent(
            "customers/#{springboard_user_id}/addresses", address_type, params, order
          )
        end
      end
    end
  end
end
