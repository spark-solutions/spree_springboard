module Spree
  CustomerReturn.class_eval do
    include SpringboardResources
    self.springboard_import_class = SpreeSpringboard::Resource::Import::CustomerReturn
  end
end
