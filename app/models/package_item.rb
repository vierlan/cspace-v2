class PackageItem < ApplicationRecord
  belongs_to :booking
  belongs_to :venue
  has_many_attached :photos
end
