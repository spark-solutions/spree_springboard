module SpreeSpringboard
  module Addresses
    class Export < SpreeSpringboard::Resources::Export
      def client(address)
        raise "Cannot sync guest's address" unless address.user.present?
        address.springboard_id ? client_update(address) : client_create(address)
      end

      def client_update(address)
        SpreeSpringboard.client["customers/#{address.user.springboard_id}/addresses/#{address.springboard_id}"]
      end

      def client_create(address)
        SpreeSpringboard.client["customers/#{address.user.prepare_springboard_id}/addresses"]
      end

      def export_params(address)
        {
          city: address.city,
          country: address.country.try(:iso),
          first_name: address.first_name,
          last_name: address.last_name,
          line_1: address.address1,
          line_2: address.address2,
          phone: address.phone,
          postal_code: address.zipcode,
          state: address.state.try(:abbr)
        }
      end
    end
  end
end
