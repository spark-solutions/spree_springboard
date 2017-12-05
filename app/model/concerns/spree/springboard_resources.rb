module Spree
  module SpringboardResources
    extend ActiveSupport::Concern
    included do
      class_attribute :springboard_export_class
      has_one :springboard_resource, as: :resource

      include SpringboardResourceId
      include SpringboardResourceSync
    end
  end
end
