module SpreeSpringboard::Resource::Clients
  module OrderClient
    def client(order)
      order.springboard_id ? client_resource(order) : client_create
    end

    def client_resource(order)
      SpreeSpringboard.client["sales/orders/#{order.springboard_id}"]
    end

    def client_create
      SpreeSpringboard.client['sales/orders']
    end
  end
end
