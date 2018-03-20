class CreateSpreeSpringboardLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :spree_springboard_logs, force: :cascade do |t|
      t.integer :resource_id
      t.string :resource_type
      t.integer :parent_id
      t.string :parent_type
      t.text :message
      t.string :message_type
      t.timestamps null: false
    end
  end
end
