module Spree
  Adjustment.class_eval do
    include SpringboardResources
    self.springboard_export_class = SpreeSpringboard::Resource::Export::Adjustment
  end
end
