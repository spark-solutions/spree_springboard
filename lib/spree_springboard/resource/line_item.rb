module SpreeSpringboard
  module Resource
    class LineItem < SpreeSpringboard::Resource::Base
      include SpreeSpringboard::Resource::Clients::LineItemClient

      def export_params(line_item)
        {
          item_id: variant_springboard_id(line_item),
          order_id: line_item.order.springboard_id,
          qty: line_item.quantity,
          adjusted_unit_price: line_item.price,
          total_tax: line_item.adjustments.tax.sum(:amount),
          created_at: line_item.created_at,
          updated_at: line_item.updated_at
        }
      end

      def variant_springboard_id(line_item)
        items = SpreeSpringboard.client["items"].
                query(public_id: line_item.variant.sku, per_page: 1).
                get.body.results
        if items.empty?
          raise "Sync variant #{line_item.variant.sku}"
        end
        items.first.id
      end
    end
  end
end
