class BookingsController < ApplicationController
  def new
    @booking = Booking.new
    @booking.user = current_user
    @booking.package = Package.find(params[:package_id])
  end

  def create

    @booking = Booking.new(booking_params)
    @booking.user = current_user
    @booking.package = Package.find(params[:package_id])

    if @booking.save
      redirect_to dashboard_path(current_user)
    else
      render :new
    end
  end

  def index
    if current_user.venue_ower?
      @bookings = Booking.where(venue_id: current_user.venue.id)
    else
      @bookings = Booking.where(user_id: current_user.id)
    end
  end

  def show
    @booking = Booking.find(params[:id])
    @package = @booking.package
    @package_items = @package.package_items
    @package_price = @package.package_price
  end

  def edit
    @booking = Booking.find(params[:id])
  end

  def update
    @booking = Booking.find(params[:id])
    @booking.update(booking_params)
    redirect_to dashboard_path(current_user)
  end

  def destroy
    @booking = Booking.find(params[:id])
    @booking.destroy
    redirect_to dashboard_path(current_user)
  end

  private

  def booking_params
    params.require(:booking).permit(:booking_date, :start_time, :package_id)
  end
end
