class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = current_user

  end

  def my_venues
    @venues = Venue.where(user: current_user)
    @user_bookings = Booking.where(user: current_user)
    @venue_bookings = current_user.venues.flat_map { |venue| venue.bookings }.sort_by { |booking| booking.created_at }.reverse

    @current_bookings = []
    @past_bookings = []
    @user_bookings.each do |booking|
      if booking.booking_date > Date.today
        @current_bookings << booking
      else
        @past_bookings << booking
      end
    end

    @current_venue_booking = []
    @past_venue_bookings = []

    @venue_bookings.each do |request|
      if request.booking_date > Date.today
        @current_venue_bookings << request
      else
        @past_venue_bookings << request
      end
    end
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
