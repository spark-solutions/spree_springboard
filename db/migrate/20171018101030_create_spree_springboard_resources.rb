class CreateSpreeSpringboardResources < ActiveRecord::Migration[5.1]
  def change
    create_table :spree_springboard_resources, force: :cascade do |t|
      t.integer :resource_id
      t.string :resource_type
      t.integer :parent_id
      t.string :parent_type
      t.integer :springboard_id
      t.timestamps null: false
    end
  end
end
