module Spree
  module SpringboardResources
    extend ActiveSupport::Concern
    included do
      class_attribute :springboard_export_class

      include SpringboardResourceId
      include SpringboardResourceSync
    end
  end
end
