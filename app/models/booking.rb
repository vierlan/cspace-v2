class Booking < ApplicationRecord
  belongs_to :venue
  belongs_to :package
  belongs_to :user


  validates :booking_date, comparison: { greater_than: Date.today }
  validates  :booking_date, :booking_start_time, presence: true
end
