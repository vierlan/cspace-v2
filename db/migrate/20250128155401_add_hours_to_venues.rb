class AddHoursToVenues < ActiveRecord::Migration[7.1]
  def change
    add_column :venues, :opening_hours, :jsonb, default: {}
  end
end
