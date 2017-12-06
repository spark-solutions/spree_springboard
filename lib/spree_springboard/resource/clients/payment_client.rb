module SpreeSpringboard::Resource::Clients
  module PaymentClient
    def client(payment)
      raise "Sync payment.order first" unless payment.order.springboard_id.present?
      client_create(payment)
    end

    def client_resource(payment)
      order_springboard_id = payment.order.springboard_id
      SpreeSpringboard.client["sales/orders/#{order_springboard_id}/payments/#{payment.springboard_id}"]
    end

    def client_create(payment)
      order_springboard_id = payment.order.springboard_id
      SpreeSpringboard.client["sales/orders/#{order_springboard_id}/payments"]
    end
  end
end
