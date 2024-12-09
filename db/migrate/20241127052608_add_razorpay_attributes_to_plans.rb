class AddRazorpayAttributesToPlans < ActiveRecord::Migration[7.0]
  def change
    rename_column :plans, :discription, :description

    # Add new columns
    add_column :plans, :razorpay_plan_id, :string, unique: true
    add_column :plans, :currency, :string, default: 'INR'
    add_column :plans, :period, :string
    add_column :plans, :interval, :integer
    
    add_index :plans, :razorpay_plan_id, unique: true
  end
end
