module SpreeSpringboard
  module InventoryImport
    class Base
      def initialize
        @in_progress = false
        @new_last_transaction_id = nil
      end

      #
      # Perform stock quantity data import from Springboard
      #
      def perform
        lock

        # Load stock data from Springboard
        springboard_stock = springboard_stock_data

        # Import each stock dota item
        springboard_stock.each do |springboard_stock_item|
          begin
            import_stock_item(springboard_stock_item)
          rescue StandardError => error
            log(error, data:
                       {
                         msg: 'Inventory Item Import Failed',
                         springboard_stock_item: springboard_stock_item
                       })
            next
          end
        end
      rescue StandardError => error
        log(error, data: { msg: 'Inventory Import Failed' })
      ensure
        ensure_last_transaction_id_updated
        # unlock only if this is the locking process
        unlock if @in_progress
      end

      def ensure_last_transaction_id_updated
        if @in_progress && @new_last_transaction_id.present?
          SpreeSpringboard.springboard_state[:last_transaction_id] = @new_last_transaction_id
        end
      end

      #
      # Mutex - there can be only one import at a time
      #
      def lock
        raise 'Inventory import already in progress' if SpreeSpringboard.springboard_state[:inventory_import_in_progress]

        SpreeSpringboard.springboard_state[:inventory_import_in_progress] = true
        @in_progress = true # set only for the locking process
      end

      def unlock
        SpreeSpringboard.springboard_state[:inventory_import_in_progress] = false
      end

      #
      # Log handler
      #
      def log(error, params)
        ExceptionNotifier.notify_exception(error, params)
      end

      #
      # Update variant's stock level using stock_item data from Springboard
      #
      def import_stock_item(springboard_stock_item)
        variant = Spree::Variant.find_by_springboard_id(springboard_stock_item[:item_id])
        return if variant.nil?

        spree_stock_item = variant.stock_items.find_by(stock_location: stock_location)
        update_stock_item(springboard_stock_item, spree_stock_item)
        variant
      end

      #
      # ImportType-specific Spree update method
      #
      def update_stock_item(_springboard_stock_item, _spree_stock_item)
        raise 'Implement for each Inventory Import type'
      end

      #
      # Spree::StockLocation for Springboard integration
      #
      def stock_location
        @stock_location = Spree::StockLocation.find_by(default: true)
      end
    end
  end
end
