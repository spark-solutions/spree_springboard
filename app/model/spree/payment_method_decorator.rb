module Spree
  PaymentMethod.class_eval do
    include SpringboardResources
  end
end
