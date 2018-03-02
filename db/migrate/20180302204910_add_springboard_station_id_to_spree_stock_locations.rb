class AddSpringboardStationIdToSpreeStockLocations < ActiveRecord::Migration[5.1]
  def change
    change_table :spree_stock_locations do |t|
      t.integer :springboard_station_id, default: nil
    end
  end
end
