module SpreeSpringboard
  module Resource
    class Payment < SpreeSpringboard::Resource::Base
      include SpreeSpringboard::Resource::Clients::PaymentClient

      def export_params(payment)
        {
          amount: payment.amount,
          custom: {},
          deposit: false
        }.merge!(payment_type(payment))
      end

      def payment_type(payment)
        payment_type_params_paypal(payment) ||
          payment_type_params_credit_card(payment) ||
          payment_type_params_store_credit(payment) ||
          payment_type_params_gift_card(payment) ||
          {}
      end

      def payment_type_params_paypal(payment)
        source = payment.source
        return if source.blank?

        if payment.source_type == "Spree::BraintreeCheckout" && source.paypal_email.present?
          {
            type: 'CustomPayment',
            payment_type_id: SpreeSpringboard.configuration.payment_type_id_paypal
          }
        end
      end

      def payment_type_params_credit_card(payment)
        source = payment.source
        return if source.blank?

        if payment.source_type == "Spree::BraintreeCheckout" && source.braintree_card_type.present?
          {
            type: 'CustomPayment',
            payment_type_id: SpreeSpringboard.configuration.payment_type_id_credit_card
          }
        end
      end

      def payment_type_params_store_credit(payment)
        if payment.source_type == "Spree::StoreCredit"
          {
            type: 'CustomPayment',
            payment_type_id: SpreeSpringboard.configuration.payment_type_id_store_credit
          }
        end
      end

      def payment_type_params_gift_card(payment)
        if payment.source_type == "Spree::GiftCard"
          {
            type: 'CustomPayment',
            payment_type_id: SpreeSpringboard.configuration.payment_type_id_gift_card
          }
        end
      end
    end
  end
end
