class AddStripeToPackages < ActiveRecord::Migration[7.1]
  def change
    add_column :packages, :stripe_id, :string, default: ""
  end
end
