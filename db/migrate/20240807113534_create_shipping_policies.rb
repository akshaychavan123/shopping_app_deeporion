class CreateShippingPolicies < ActiveRecord::Migration[7.0]
  def change
    create_table :shipping_policies do |t|
      t.string :heading
      t.text :description

      t.timestamps
    end
  end
end
