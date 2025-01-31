class AddClaimedToVenues < ActiveRecord::Migration[7.1]
  def change
    add_column :venues, :claimed, :boolean
  end
end
