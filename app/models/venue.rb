class Venue < ApplicationRecord
  CATEGORIES = %w[bar restaurant cafe hotel other]
  belongs_to :user
  has_many_attached :photos
  has_many :bookings
  has_many :package_items

  validates :name, presence: true
  #validates :categories, inclusion: { in: CATEGORIES }
end
