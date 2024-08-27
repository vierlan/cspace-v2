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
    @package = Package.find(params[:package_id])
    @venue = @package.venue
    @booking.package = @package
    @booking.venue = @venue
    @stripe_price_id = @package.stripe_price_id
    @booking_date = params[:booking][:booking_date]
    @booking_start_time = params[:booking][:booking_start_time]

    if @booking.valid? && @booking.save
      @booking_id = @booking.id
      readable_time = readable_date_time(@booking.booking_date, @booking.booking_start_time)
      Rails.logger.info "Booking time: #{readable_time}"
      @booking.update(booking_start_time: readable_time)
      Rails.logger.info "Booking created with ID: #{@booking_id}, booking date: #{@booking_date}, booking start time: #{@booking_start_time}"
      @checkout_session = create_stripe_checkout_session(@booking)
      redirect_to @checkout_session.url, status: 303, allow_other_host: true
      Rails.logger.info "Redirecting to Stripe checkout session URL: #{@checkout_session.url}"
    else
      Rails.logger.error "Booking save failed: #{@booking.errors.full_messages.join(', ')}"
      flash.now[:error] = 'Something went wrong'

      render 'packages/show', status: :unprocessable_entity, id: @booking.package.id
    end
  end

  def create_stripe_checkout_session(booking)
    Stripe.api_key = ENV['STRIPE_SECRET_KEY']
    @booking = booking
    @booking_id = @booking.id
    @booking_start_time = @booking.booking_start_time
    @booking_date = @booking.booking_date
    @package = @booking.package
    @venue = @package.venue
    @stripe_price_id = @package.stripe_price_id
    current_user.set_payment_processor :stripe
    current_user.payment_processor.customer
    Rails.logger.info "Creating Stripe checkout session with price ID: #{@stripe_price_id}, booking ID: #{@booking_id}, booking date: #{@booking_date}, booking start time: #{@booking_start_time}"
    begin
      @checkout_session = current_user
                            .payment_processor
                            .checkout(
                              mode: 'payment',
                              line_items: [{
                                price: @stripe_price_id,
                                quantity: 1
                              }],
                              metadata: {
                                venue_id: @venue.id,
                                package_id: @package.id,
                                booking_date: @booking_date,
                                booking_start_time: @booking_start_time,
                                booking_id: @booking_id
                              },
                              custom_text: {
                                submit: {
                                  message: "Your Booking: #{@booking_date} #{@booking_start_time} @ #{@venue.name} "
                                }

                              },
                              success_url: checkout_success_url,
                              cancel_url: checkout_cancel_url
                            )
    rescue Stripe::InvalidRequestError => e
      Rails.logger.error "Stripe error: #{e.message}"
      flash[:error] = "There was a problem creating the Stripe checkout session: #{e.message}"
      redirect_to new_booking_path
    end
  end

  def index
      @bookings = current_user.bookings.order(created_at: :desc)
      @current_bookings = []
      @past_bookings = []
      @bookings.each do |booking|
        if booking.booking_date > Date.today
          @current_bookings << booking
        else
          @past_bookings << booking
        end
    end
  end

  def venue_bookings
    @venues = current_user.venues
    @bookings = current_user.venues.flat_map { |venue| venue.bookings }.sort_by { |booking| booking.created_at }.reverse
    @current_bookings = []
    @past_bookings = []
    @bookings.each do |booking|
      if booking.booking_date > Date.today
        @current_bookings << booking
      else
        @past_bookings << booking
      end
  end
end


  def show
    @booking = Booking.find(params[:id])
    @package = @booking.package
    @venue = @package.venue
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
  end

  private

  def readable_date_time(date, time)
    DateTime.parse("#{date} #{time}").strftime('%d %m %Y at %H:%M')
  end

  def booking_params
    params.require(:booking).permit(:booking_date, :booking_start_time)
  end
end
