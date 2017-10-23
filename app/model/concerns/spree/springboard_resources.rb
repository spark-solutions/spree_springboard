module Spree
  module SpringboardResources
    extend ActiveSupport::Concern
    included do
      include SpringboardResourceElement
      include SpringboardResourceSync
    end
  end
end
