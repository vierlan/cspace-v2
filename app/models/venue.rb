class Venue < ApplicationRecord
  CATEGORIES = %w[bar restaurant cafe hotel other]
  belongs_to :user
  has_many_attached :photos

  validates :name, presence: true
  validates :category, inclusion: { in: CATEGORIES }
end
