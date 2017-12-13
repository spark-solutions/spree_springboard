module Spree
  module SpringboardResources
    extend ActiveSupport::Concern
    included do
      include SpringboardResourceId
      include SpringboardResourceImport
      include SpringboardResourceExport
      include SpringboardResourceSync
    end
  end
end
