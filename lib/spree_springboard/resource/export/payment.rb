module SpreeSpringboard
  module Resource
    module Export
      class Payment < SpreeSpringboard::Resource::Export::Base
        include SpreeSpringboard::Resource::Clients::PaymentClient

        def export_params(payment, _params = {})
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
end
