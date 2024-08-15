class Booking < ApplicationRecord
  belongs_to :venue
  belongs_to :package
  belongs_to :user
end
