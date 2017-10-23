module Spree
  Adjustment.class_eval do
    include SpringboardResourceElement
    self.springboard_export_class = SpreeSpringboard::Resource::Adjustment
  end
end
