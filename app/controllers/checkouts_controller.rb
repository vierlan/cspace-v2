class CheckoutsController < ApplicationController
  before_action :authenticate_user!

  def success
    @session = Stripe::Checkout::Session.retrieve(params[:session_id])
    @line_items = Stripe::Checkout::Session.list_line_items(params[:session_id])
    @booking = Booking.find(@session.metadata.booking_id)
    @booking_date = @booking.booking_date
    @booking_start_time = @booking.booking_start_time
    @readable_booking_date = @booking_date.strftime('%A, %B %d, %Y')
    @readable_booking_start_time = @booking_start_time.strftime('%I:%M %p')
    @venue = Venue.find(@session.metadata.venue_id)
    @venue_name = @venue.name
    @booking.update(booking_paid: true)



  end

  def cancel

  end

  def failure

  end

end
