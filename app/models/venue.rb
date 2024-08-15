class Venue < ApplicationRecord
  CATEGORIES = %w[bar restaurant cafe hotel other]

  belongs_to :user
  has_many_attached :photos
  has_many :bookings, dependent: :destroy
  has_many :packages, dependent: :destroy

  validates :name, presence: true
  #validates :categories, inclusion: { in: CATEGORIES }
end
