class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = current_user
  end

  def show
    @user = current_user
  end

  def new
    @user = current_user
  end

  def create_profile
    @user = current_user


  end


  def Profile
    @profile = { first_name: '', last_name: '', bio: '', :venue_owner => false }
  end


  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @profile.update(user_params)
      redirect_to dashboard_path, notice: 'Profile updated successfully'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :bio, :avatar)
  end
end
