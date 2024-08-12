class RegistrationsController < Devise::RegistrationsController
  before_action :protect_from_spam, only: [:create]

  def after_sign_up_path_for(resource)
    onboarding_steps_path
  end

  def update
    current_user.update(account_update_params)
    sign_in(current_user, bypass: true) # prevents user from needing to log back in
    redirect_to account_index_path, notice: 'Profile updated successfully'
  end

  private

  def account_update_params
    params.require(:user).permit(:email, :password, :first_name, :last_name, :avatar, :bio, :password_confirmation)
  end


end
