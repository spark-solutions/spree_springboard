module Spree
  StockLocation.class_eval do
    include SpringboardResources
    include SpringboardResourceParent
  end
end
