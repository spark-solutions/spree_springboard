module Spree
  class SpringboardResource < ActiveRecord::Base
    belongs_to :resource, polymorphic: true
    belongs_to :parent, polymorphic: true
  end
end
