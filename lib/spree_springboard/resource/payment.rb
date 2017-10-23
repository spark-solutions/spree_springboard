module SpreeSpringboard
  module Resource
    class Payment < SpreeSpringboard::Resource::Base
      include SpreeSpringboard::Resource::Clients::PaymentClient

      def export_params(payment)
        {
          type: "CashPayment",
          amount: payment.amount
        }
      end

      def payment_types
        ["CashPayment", "CreditCardPayment", "CheckPayment", "CustomPayment", "ExternalPayment"]
      end
    end
  end
end
