class AddSpringboardExportedAtToSpreeOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :spree_orders, :springboard_exported_at, :datetime, default: nil
  end
end
