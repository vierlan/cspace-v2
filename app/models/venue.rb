class Venue < ApplicationRecord
  CATEGORIES = %w[bar restaurant cafe hotel other]

  belongs_to :user
  has_many_attached :photos
  has_many :bookings, dependent: :destroy
  has_many :packages, dependent: :destroy

  validates :name, presence: true

  geocoded_by :address
  after_validation :geocode, if: :address_changed?

  def distance_from_user(user)
    Geocoder::Calculations.distance_between([latitude, longitude], [user.latitude, user.longitude])
  end
  #validates :categories, inclusion: { in: CATEGORIES }
end
