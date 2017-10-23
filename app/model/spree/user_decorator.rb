module Spree
  User.class_eval do
    include SpringboardResourceElement
    self.springboard_export_class = SpreeSpringboard::Resource::User
  end
end
