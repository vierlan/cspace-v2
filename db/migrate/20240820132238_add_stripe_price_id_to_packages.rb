class AddStripePriceIdToPackages < ActiveRecord::Migration[7.1]
  def change
    add_column :packages, :stripe_price_id, :string
    add_column :packages, :data, :json
  end
end
