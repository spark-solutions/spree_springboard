module SpreeSpringboard
  module Resource
    class Payment < SpreeSpringboard::Resource::Base
      include SpreeSpringboard::Resource::Clients::PaymentClient

      def export_params(payment)
        {
          amount: payment.amount,
          deposit: false,
          type: payment_type(payment)
        }
      end

      def payment_type(payment)
        source = payment.source
        return "CashPayment" if blank?
        if payment.source_type == "Spree::BraintreeCheckout" && source.paypal_email.present?
          "PayPal"
        elsif payment.source_type == "Spree::BraintreeCheckout" && source.braintree_card_type.present?
          "CreditCardPayment"
        else
          "CashPayment"
        end
      end

      def payment_types
        ["CashPayment", "CreditCardPayment", "CheckPayment", "CustomPayment", "ExternalPayment"]
      end
    end
  end
end
