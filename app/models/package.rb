class Package < ApplicationRecord
  belongs_to :venue
  has_many :bookings
  has_one_attached :photo, service: :cloudinary, dependent: :purge

def cloudinary_purge(photo)
  Cloudinary::Api.delete_resources_by_prefix("development/#{photo.key}")
end

def delete_stripe_package(package)
  return if package.stripe_id.blank?
  Stripe.api_key = ENV['STRIPE_SECRET_KEY']
  # archive the product in stripe
  stripe_product = Stripe::Product.update(package.stripe_id, {active: false})
  package.update(
    stripe_id: nil,
    stripe_price_id: nil,
    data: nil
  )
end

end
