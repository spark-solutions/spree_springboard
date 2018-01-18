module SpreeSpringboard
  module Resource
    module Export
      class LineItem < SpreeSpringboard::Resource::Export::Base
        include SpreeSpringboard::Resource::Clients::LineItemClient

        def adjustments(line_item)
          line_item.order.adjustments.non_tax.where.not(source_type: 'Spree::Shipment')
        end

        def calculate_adjusted_unit_price(line_item)
          line_item.price + (discounts_amount(line_item) / line_item.quantity).round(2)
        end

        def calculate_total_tax(line_item)
          line_item.adjustments.tax.sum(:amount)
        end

        def export_params(line_item, _params = {})
          {
            adjusted_unit_price: calculate_adjusted_unit_price(line_item),
            item_id: variant_springboard_id(line_item),
            order_id: line_item.order.springboard_id,
            original_unit_price: line_item.price,
            qty: line_item.quantity,
            ship_from_location_id: SpreeSpringboard.configuration.source_location_id,
            total_tax: calculate_total_tax(line_item),
            created_at: line_item.created_at,
            updated_at: line_item.updated_at
          }
        end

        def discounts(line_item)
          discounts_per_line_item(line_item) + discounts_per_order(line_item)
        end

        def discounts_per_line_item(line_item)
          discounts = []
          if line_item.taxable_adjustment_total != 0
            discounts << { description: 'Line Item Adjustment', amount: line_item.taxable_adjustment_total }
          end
          discounts
        end

        def discounts_per_order(line_item)
          discounts = []
          order_adjustment_total = adjustments(line_item).sum(:amount)

          unless order_adjustment_total.zero?
            line_item_price_total = line_item.order.line_items.sum(:price)
            ratio = (line_item.price / line_item_price_total).round(2)
            discounts << {
              description: "Adjustments: #{adjustments(line_item).map(&:label).join(', ')}",
              amount: ratio * order_adjustment_total
            }
          end
          discounts
        end

        def discounts_amount(line_item)
          discounts(line_item).map { |discount| discount[:amount] }.sum
        end

        def variant_springboard_id(line_item)
          v_springboard_id = line_item.variant.springboard_id
          return v_springboard_id if v_springboard_id.present?

          items = SpreeSpringboard.client['items'].
                  query(public_id: line_item.variant.sku, per_page: 1).
                  get.body.results
          raise "Sync variant #{line_item.variant.sku}" if items.empty?
          line_item.variant.springboard_id = items.first.id
        end
      end
    end
  end
end
