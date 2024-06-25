class AddTermsAndConditionToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :terms_and_condition, :boolean
  end
end
