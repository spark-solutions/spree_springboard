module Spree
  ShippingMethod.class_eval do
    include SpringboardResourceId

    def springboard_sync!
      false
    end
  end
end
