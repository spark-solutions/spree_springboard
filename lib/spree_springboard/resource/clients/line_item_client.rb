module SpreeSpringboard::Resource::Clients
  module LineItemClient
    def client(line_item)
      raise "Sync line_item.order first" unless line_item.order.springboard_id.present?
      line_item.springboard_id ? client_resource(line_item) : client_create(line_item)
    end

    def client_resource(line_item)
      order_springboard_id = line_item.order.springboard_id
      SpreeSpringboard.client["sales/orders/#{order_springboard_id}/lines/#{line_item.springboard_id}"]
    end

    def client_create(line_item)
      order_springboard_id = line_item.order.springboard_id
      SpreeSpringboard.client["sales/orders/#{order_springboard_id}/lines"]
    end
  end
end
