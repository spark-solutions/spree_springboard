module SpreeSpringboard
  module Resource
    class Adjustment < SpreeSpringboard::Resource::Base
      include SpreeSpringboard::Resource::Clients::AdjustmentClient

      def self.adjustment_type(adjustment)
        adjustment.class.where(id: adjustment.id).tax.any? ? 'tax' : 'discount'
      end

      def export_params(adjustment)
        if self.class.adjustment_type(adjustment) == 'tax'
          export_params_tax(adjustment)
        else
          export_params_discount(adjustment)
        end
      end

      def export_params_tax(adjustment)
        tax_description = [
          adjustment.label,
          adjustment.try(:adjustable).try(:name)
        ].reject(&:blank?).join(' - ')
        {
          description: tax_description,
          value: adjustment.amount
        }
      end

      def export_params_discount(adjustment)
        {
          description: adjustment.label,
          value: adjustment.amount
        }
      end
    end
  end
end
