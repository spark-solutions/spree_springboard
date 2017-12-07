module SpreeSpringboard
  module Resource
    class Payment < SpreeSpringboard::Resource::Base
      include SpreeSpringboard::Resource::Clients::PaymentClient

      def export_params(payment)
        {
          amount: payment.amount,
          custom: {},
          deposit: false,
          type: 'CustomPayment',
          payment_type_id: payment.payment_method.springboard_id
        }
      end
    end
  end
end
