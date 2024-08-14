class Booking < ApplicationRecord
  belongs_to :venue
  belongs_to :user
  has_many :package_items
end
