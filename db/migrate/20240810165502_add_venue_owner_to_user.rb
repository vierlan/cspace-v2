class AddVenueOwnerToUser < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :venue_owner, :boolean, default: false
  end
end
