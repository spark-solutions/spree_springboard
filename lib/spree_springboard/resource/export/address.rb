module SpreeSpringboard
  module Resource
    module Export
      class Address < SpreeSpringboard::Resource::Export::Base
        include SpreeSpringboard::Resource::Clients::AddressClient

        def export_params(address, _params = {})
          {
            city: address.city.to_s.strip,
            country: address.country.try(:iso),
            first_name: address.firstname.to_s.strip,
            last_name: address.lastname.to_s.strip,
            line_1: address.address1.to_s.strip,
            line_2: address.address2,
            phone: address.phone,
            postal_code: address.zipcode.to_s.strip,
            state: address.state.try(:abbr)
          }
        end
      end
    end
  end
end
