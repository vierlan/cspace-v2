class AddPhoneNumberToVenues < ActiveRecord::Migration[7.1]
  def change
    add_column :venues, :phone_number, :string
    add_column :venues, :website, :string
    add_column :venues, :venue_email, :string
  end
end
