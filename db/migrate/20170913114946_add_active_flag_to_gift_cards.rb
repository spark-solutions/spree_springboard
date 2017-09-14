class AddActiveFlagToGiftCards < ActiveRecord::Migration[5.1]
  def change
    add_column :spree_gift_cards, :active, :boolean, default: false, null: false
    add_column :spree_gift_cards, :springboard_id, :integer
  end
end
