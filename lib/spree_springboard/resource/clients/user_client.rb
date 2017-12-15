module SpreeSpringboard::Resource::Clients
  module UserClient
    def client(user)
      user.springboard_id ? client_resource(user) : client_create
    end

    def client_resource(user)
      SpreeSpringboard.client["customers/#{user.springboard_id}"]
    end

    def client_create
      SpreeSpringboard.client['customers']
    end
  end
end
