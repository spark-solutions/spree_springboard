module Spree
  Address.class_eval do
    include SpringboardResourceElement
    self.springboard_export_class = SpreeSpringboard::Resource::Address
  end
end
