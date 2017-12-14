module Spree
  ReturnAuthorization.class_eval do
    include SpringboardResources
    self.springboard_import_class = SpreeSpringboard::Resource::Import::ReturnAuthorization
  end
end
