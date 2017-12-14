module Spree
  LineItem.class_eval do
    include SpringboardResources
    self.springboard_export_class = SpreeSpringboard::Resource::Export::LineItem
  end
end
