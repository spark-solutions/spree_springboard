module SpreeSpringboard::Resource::Clients
  module AddressClient
    def client(address)
      raise "Cannot sync guest's address" unless address.user.present?
      address.springboard_id ? client_resource(address) : client_create(address)
    end

    def client_resource(address)
      SpreeSpringboard.client["customers/#{address.user.springboard_id}/addresses/#{address.springboard_id}"]
    end

    def client_create(address)
      SpreeSpringboard.client["customers/#{address.user.prepare_springboard_id}/addresses"]
    end
  end
end
