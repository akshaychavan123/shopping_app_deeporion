class ModifyTermsAndConditions < ActiveRecord::Migration[7.0]
  def change
    rename_column :terms_and_conditions, :content, :description
    remove_column :terms_and_conditions, :version, :integer
  end
end
