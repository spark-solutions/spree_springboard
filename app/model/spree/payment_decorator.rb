module Spree
  Payment.class_eval do
    include SpringboardResourceElement
    self.springboard_export_class = SpreeSpringboard::Resource::Payment
  end
end
