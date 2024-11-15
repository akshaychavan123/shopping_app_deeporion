class CreateApiV1HelpCenters < ActiveRecord::Migration[7.0]
  def change
    create_table :help_centers do |t|
      t.string :question
      t.string :answer
      t.string :description
      t.timestamps
    end
  end
end
