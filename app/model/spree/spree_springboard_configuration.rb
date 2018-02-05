module Spree
  class SpreeSpringboardConfiguration < Preferences::Configuration
    preference :inventory_import_in_progress, :boolean, default: false
  end
end
