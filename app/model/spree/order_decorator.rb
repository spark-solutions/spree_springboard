module Spree
  Order.class_eval do
    include SpringboardResourceElement
    include SpringboardResourceParent
    self.springboard_export_class = SpreeSpringboard::Resource::Order
  end
end
