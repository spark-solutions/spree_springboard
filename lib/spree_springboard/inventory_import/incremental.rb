module SpreeSpringboard
  module InventoryImport
    class Incremental < SpreeSpringboard::InventoryImport::Base
      #
      # Download incremental stock_data from Sprinboard
      # Do so by getting all the transactions from the last saved transaction ID
      # incrementally update
      #
      def springboard_stock_data(stock_location, _fail_count = 0)
        # Get inventory transactions since the last id stored in Spree
        last_transaction_id = stock_location.child_springboard_id('last_transaction_id')
        raise "Run full import for #{stock_location.name} before incremental" if last_transaction_id.nil?

        # Cannot pass delta_qty_committed != null when using a hash of query parameters
        filter = "_filter={\"id\":{\"$gt\":#{last_transaction_id}},\"delta_qty_committed\":{\"$neq\":null}}"
        query = "per_page=500&location_id=#{stock_location.springboard_id}"
        url = '/api/inventory/transactions'

        SpreeSpringboard.client["#{url}?#{query}&#{filter}"].get.body.results
      end

      #
      # ImportType-specific Spree update method
      #
      def update_stock_item(springboard_transaction_item, spree_stock_item)
        spree_stock_item.adjust_count_on_hand(springboard_transaction_item[:delta_qty_committed])
        @new_last_transaction_id = springboard_transaction_item[:id]
      end
    end
  end
end
