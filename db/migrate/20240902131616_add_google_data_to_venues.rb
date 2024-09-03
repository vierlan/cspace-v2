class AddGoogleDataToVenues < ActiveRecord::Migration[7.1]
  def change
    add_column :venues, :google_data, :json
  end
end
