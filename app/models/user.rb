class User < ApplicationRecord
  has_many :assignments, dependent: :destroy
  has_many :roles, through: :assignments
  has_one_attached :photo
  include Signupable
  include Onboardable
  include Billable

  scope :subscribed, -> { where.not(stripe_subscription_id: [nil, '']) }

  def role?(role, entity_id = nil)
    if entity_id.present?
      roles.where(name: role, entity_id: entity_id).exists?
    else
      roles.where(name: role).exists?
    end
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
