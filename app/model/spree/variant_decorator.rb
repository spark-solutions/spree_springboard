module Spree
  Variant.class_eval do
    include SpringboardResourceId

    def sync_springboard
      false
    end
  end
end
