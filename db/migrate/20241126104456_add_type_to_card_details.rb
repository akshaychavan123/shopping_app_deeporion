class AddTypeToCardDetails < ActiveRecord::Migration[7.0]
  def change
    add_column :card_details, :card_type, :string
  end
end
