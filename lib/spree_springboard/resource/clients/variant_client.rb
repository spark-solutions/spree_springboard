module SpreeSpringboard::Resource::Clients
  module VariantClient
    def client_query
      SpreeSpringboard.client[:items]
    end
  end
end
