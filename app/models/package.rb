class Package < ApplicationRecord
  belongs_to :venue
  has_many :bookings
  has_one_attached :photo
end
