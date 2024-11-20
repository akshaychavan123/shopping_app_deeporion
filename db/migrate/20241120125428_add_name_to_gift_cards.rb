class AddNameToGiftCards < ActiveRecord::Migration[7.0]
  def change
    add_column :gift_cards, :name, :string
  end
end
