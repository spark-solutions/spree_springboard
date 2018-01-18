module SpreeSpringboard
  module Resource
    module Export
      class Address < SpreeSpringboard::Resource::Export::Base
        include SpreeSpringboard::Resource::Clients::AddressClient

        def export_params(address, _params = {})
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
end
