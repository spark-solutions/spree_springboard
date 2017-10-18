module Spree
  Order.class_eval do
    include SpringboardResourceElement
    self.springboard_export_class = SpreeSpringboard::Orders::Export
  end
end
