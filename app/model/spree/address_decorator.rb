module Spree
  Address.class_eval do
    include SpringboardResources
    self.springboard_export_class = SpreeSpringboard::Resource::Export::Address
  end
end
