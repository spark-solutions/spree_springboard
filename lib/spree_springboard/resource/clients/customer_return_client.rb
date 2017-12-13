module SpreeSpringboard::Resource::Clients
  module CustomerReturnClient
    def client(customer_return)
      client_resource(customer_return)
    end

    def client_query(filter_params = {})
      url = query_url(filter_params)
      SpreeSpringboard.client[url]
    end

    def client_query_last_day(filter_params = {})
      url_date = (Time.now - 1.day).strftime("%Y-%m-%d")
      url = query_url(filter_params) + "&_filter[created_at][$gt]=#{url_date}"
      SpreeSpringboard.client[url]
    end

    def client_resource(customer_return)
      SpreeSpringboard.client["sales/tickets/#{customer_return.springboard_id}"]
    end

    private

    def query_url(filter_params = {})
      url = 'sales/tickets?_filter[type][$eq]=Return'
      url + filter_params.map { |param| "&#{param}" }.join('')
    end
  end
end
