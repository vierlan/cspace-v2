class AddSpacesToVenues < ActiveRecord::Migration[7.1]
  def change
    add_column :venues, :spaces, :json
  end
end
