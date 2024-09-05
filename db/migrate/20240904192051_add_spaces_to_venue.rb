class AddSpacesToVenue < ActiveRecord::Migration[7.1]
  def change
    add_column :venues, :spaces, :jsonb
  end
end
