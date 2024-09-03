class Venue < ApplicationRecord
  CATEGORIES = %w[bar restaurant cafe hotel other]

  belongs_to :user
  has_many_attached :photos
  has_many :bookings, dependent: :destroy
  has_many :packages, dependent: :destroy

  validates :name, presence: true

  geocoded_by :address
  after_validation :geocode, if: :address_changed?

  private

  def get_city(latitude, longitude)
    result = Geocoder.search([latitude, longitude])
    if result.present?
      city = result.first.city
    else
      return nil
    end
  end


  #validates :categories, inclusion: { in: CATEGORIES }
end
