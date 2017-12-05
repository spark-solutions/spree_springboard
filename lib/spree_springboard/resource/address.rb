module SpreeSpringboard
  module Resource
    class Address < SpreeSpringboard::Resource::Base
      include SpreeSpringboard::Resource::Clients::AddressClient

      def export_params(address)
        {
          city: address.city,
          country: address.country.try(:iso),
          first_name: address.firstname,
          last_name: address.lastname,
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
