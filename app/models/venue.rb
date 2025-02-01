class Venue < ApplicationRecord
  attr_accessor :user_email

  before_create :set_default_claimed
  CATEGORIES = %w[bar restaurant cafe hotel other]

  belongs_to :user
  has_many_attached :photos
  has_many_attached :videos
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
    city
  end

  def set_default_claimed
    if self.claimed.nil? && user.admin?
      self.claimed = false
    elsif self.claimed.nil? && !user.admin?
      self.claimed = true
    end
  end

  #validates :categories, inclusion: { in: CATEGORIES }
end
