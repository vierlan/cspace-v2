class BookingsController < ApplicationController
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

    if @booking.save
      @booking_id = @booking.id
      Rails.logger.info "Booking created with ID: #{@booking_id}, booking date: #{@booking_date}, booking start time: #{@booking_start_time}"
      @checkout_session = create_stripe_checkout_session(@booking)
      redirect_to @checkout_session.url, status: 303, allow_other_host: true
      Rails.logger.info "Redirecting to Stripe checkout session URL: #{@checkout_session.url}"

     #respond_to do |format|
     #  format.html { redirect_to @checkout_session.url, allow_other_host: true }
     #  format.turbo_stream { render turbo_stream: turbo_stream.replace("checkout_redirect", partial: "shared/redirect", locals: { url: @checkout_session.url }) }
     #end
    else
      Rails.logger.error "Booking save failed: #{@booking.errors.full_messages.join(', ')}"
      flash.now[:error] = 'Something went wrong'
      render :new, status: :unprocessable_entity
    end
  end

  def create_stripe_checkout_session(booking)
    Stripe.api_key = ENV['STRIPE_SECRET_KEY']
    @booking = booking
    @booking_id = @booking.id
    @booking_start_time = @booking.booking_start_time
    @booking_date = @booking.booking_date
    @package = Package.find(params[:package_id])
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
    if current_user.venue_owner?
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
    params.require(:booking).permit(:booking_date, :booking_start_time)
  end
end
