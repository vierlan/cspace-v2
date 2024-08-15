class OnboardingStepsController < ApplicationController
  include Wicked::Wizard

  steps :add_names, :add_venue_owner, :add_avatar

  def show
    @user = current_user
    render_wizard
  end

  def update
    @user = current_user

    if @user.update(user_params)
      if step == steps.last
        finish_wizard
      else
        render_wizard @user
      end
    else
      render_wizard @user, status: :unprocessable_entity
    end
  end

  private

  def finish_wizard
    redirect_to dashboard_path(current_user), notice: "Thank you for signing up."
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :venue_owner, :avatar)
  end
end
