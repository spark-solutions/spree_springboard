module Spree
  class SpreeSpringboardConfiguration < Preferences::Configuration
    preference :last_transaction_id, :integer, default: 0
    preference :inventory_import_in_progress, :boolean, default: false
  end
end
