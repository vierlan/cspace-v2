class BookingsController < ApplicationController
  before_action :authenticate_user!

  def new
    @booking = Booking.new
    @booking.user = current_user
    @booking.package = Package.find(params[:package_id])
  end

  def create
    @booking = Booking.new(booking_params)
    @booking.user = current_user
    @booking.package = Package.find(params[:package_id])
    @booking.venue = @booking.package.venue

    if @booking.save
      Stripe.api_key = ENV['STRIPE_SECRET_KEY']
      current_user.set_payment_processor :stripe
      current_user.payment_processor.customer
      @checkout_session = current_user
                          .payment_processor
                          .checkout(
                            mode: 'payment',
                            line_items: 'price_1PpvXoRszoiavRvriwLx0Fqy',
                            success_url: checkout_success_url,
                            cancel_url: checkout_cancel_url,
                          )
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
    @packages = @package.packages
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
    params.require(:booking).permit(:booking_date, :booking_start_time, :package_id)
  end
end
