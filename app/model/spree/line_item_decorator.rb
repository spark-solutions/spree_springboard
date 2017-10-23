module Spree
  LineItem.class_eval do
    include SpringboardResourceElement
    self.springboard_export_class = SpreeSpringboard::Resource::LineItem
  end
end
