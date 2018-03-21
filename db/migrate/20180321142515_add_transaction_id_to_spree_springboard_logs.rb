class AddTransactionIdToSpreeSpringboardLogs < ActiveRecord::Migration[5.1]
  def change
    add_column :spree_springboard_logs, :transaction_id, :string, default: nil
  end
end
