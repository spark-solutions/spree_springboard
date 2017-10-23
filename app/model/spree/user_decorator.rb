module Spree
  User.class_eval do
    include SpringboardResources
    self.springboard_export_class = SpreeSpringboard::Resource::User
  end
end
