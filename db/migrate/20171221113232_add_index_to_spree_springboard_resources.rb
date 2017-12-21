class AddIndexToSpreeSpringboardResources < ActiveRecord::Migration[5.1]
  def change
    change_table :spree_springboard_resources do |t|
      t.index [:springboard_id], name: "index_spree_springboard_resources_springboard_id"
      t.index [:resource_id], name: "index_spree_springboard_resources_resource_id"
      t.index [:parent_id], name: "index_spree_springboard_resources_parent_id"
      t.index [:resource_type], name: "index_spree_springboard_resources_springboard_type"
      t.index [:parent_type], name: "index_spree_springboard_resources_parent_type"
      t.index [:resource_id, :resource_type], name: "index_spree_springboard_resources_resource"
      t.index [:parent_id, :parent_type], name: "index_spree_springboard_resources_parent"
      t.index [:resource_id, :resource_type, :springboard_id], name: "index_spree_springboard_resources_resource_by_springboard_id"
      t.index [:resource_type, :springboard_id], name: "index_spree_springboard_resources_resource_type_springboard_id"
      t.index [:parent_type, :springboard_id], name: "index_spree_springboard_resources_parent_by_springboard_id"
    end
  end
end
