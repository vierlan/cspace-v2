class RegistrationsController < Devise::RegistrationsController
  before_action :protect_from_spam, only: [:create]

  def after_sign_up_path_for(resource)
    onboarding_path # or the appropriate path helper for your onboarding#create action
  end
end
