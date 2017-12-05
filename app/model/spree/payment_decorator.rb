module Spree
  Payment.class_eval do
    include SpringboardResources
    self.springboard_export_class = SpreeSpringboard::Resource::Payment
  end
end
