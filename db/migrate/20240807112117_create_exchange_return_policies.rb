class CreateExchangeReturnPolicies < ActiveRecord::Migration[7.0]
  def change
    create_table :exchange_return_policies do |t|
      t.string :heading
      t.text :description

      t.timestamps
    end
  end
end
