class Venue < ApplicationRecord
  CATEGORIES = %w[bar restaurant cafe hotel other]
  belongs_to :user
  has_many_attached :photos

  validates :name, presence: true
  #validates :categories, inclusion: { in: CATEGORIES }
end
