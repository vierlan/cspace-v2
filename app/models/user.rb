class User < ApplicationRecord
  has_many :assignments, dependent: :destroy
  has_many :roles, through: :assignments
  has_many :venues, dependent: :destroy
  has_one_attached :avatar
  include Signupable
  include Onboardable
  include Billable

  scope :subscribed, -> { where.not(stripe_subscription_id: [nil, '']) }

  def full_name
    "#{first_name.capitalize} #{last_name.capitalize}"
  end


  # :nocov:
  def self.ransackable_attributes(*)
    ["id", "admin", "created_at", "updated_at", "email", "stripe_customer_id", "stripe_subscription_id", "paying_customer"]
  end

  def self.ransackable_associations(_auth_object)
    []
  end
  # :nocov:



end
