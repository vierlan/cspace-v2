class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = current_user

  end

  def my_venues
    @venues = Venue.where(user: current_user)
    @user_bookings = Booking.where(user: current_user)
  end
  


  def my_venue_packages
    @venue = Venue.find(params[:id])
    @packages = Package.where(venue: @venue)
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

  def venue_owner?
    if Venue.find(params[user_id]) == current_user.id
      return true
    else
      return false
    end
  end


  def user_params
    params.require(:user).permit(:first_name, :last_name, :bio, :avatar)
  end

end
