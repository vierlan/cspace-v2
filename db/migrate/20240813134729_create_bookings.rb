class CreateBookings < ActiveRecord::Migration[7.1]
  def change
    create_table :bookings do |t|
      t.date :booking_date
      t.time :booking_start_time
      t.integer :booking_duration
      t.boolean :booking_confirmed
      t.boolean :booking_paid
      t.decimal :booking_cost, precision: 4, scale: 2
      t.references :venue, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
