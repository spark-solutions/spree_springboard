module Spree
  class SpringboardResource < ActiveRecord::Base
    include Spree::RansackableAttributes

    belongs_to :resource, polymorphic: true
    belongs_to :parent, polymorphic: true
  end
end
