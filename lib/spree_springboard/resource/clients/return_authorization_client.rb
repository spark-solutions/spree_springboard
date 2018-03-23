module SpreeSpringboard::Resource::Clients
  module ReturnAuthorizationClient
    def client(return_authorization)
      client_resource(return_authorization)
    end

    def client_query(filter_params = {})
      url = query_url(filter_params)
      SpreeSpringboard.client[url]
    end

    def client_query_last_day(filter_params = {})
      url = query_url(filter_params) +
        "&per_page=all&_filter[created_at][$gt]=#{1.day.ago.strftime('%Y-%m-%d')}&" +
        stock_locations_springboard_ids.map { |id| "_filter[source_location_id][$in][]=#{id}" }.join('&')
      SpreeSpringboard.client[url]
    end

    def client_resource(return_authorization)
      SpreeSpringboard.client["sales/tickets/#{return_authorization.springboard_id}"]
    end

    private

    def stock_locations_springboard_ids
      Spree::StockLocation.springboard_synced.map(&:springboard_id)
    end

    def query_url(filter_params = {})
      url = 'sales/tickets?_filter[type][$eq]=Return'
      url + filter_params.map { |param| "&#{param}" }.join('')
    end
  end
end
