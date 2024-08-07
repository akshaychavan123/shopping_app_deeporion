class CreateCareers < ActiveRecord::Migration[7.0]
  def change
    create_table :careers do |t|
      t.text :header

      t.timestamps
    end
  end
end
