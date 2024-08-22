class PackagesController < ApplicationController
  def new
    @package = Package.new
    @venue = Venue.find(params[:venue_id])
  end

  def create
    @package = Package.new(item_params)
    @package.venue_id = params[:venue_id]
    @venue = Venue.find(params[:venue_id])


    if @package.save
      Stripe.api_key = ENV['STRIPE_SECRET_KEY']
      service = StripePackage.new(params, @package)
      service.create_package
      redirect_to my_venue_packages_path(@venue)
    else
      render :new ,status: :unprocessable_entity
    end
  end

  def index
    @packages = Package.find(params[:id])
    @venue = Venue.find(params[:venue_id])
  end

  def show
    @package = Package.find(params[:id])
    @venue = Venue.find(params[:venue_id])
    @booking = Booking.new
    @stripe_price_id = @package.stripe_price_id
    Stripe.api_key = ENV['STRIPE_SECRET_KEY']
    current_user.set_payment_processor :stripe
    current_user.payment_processor.customer
    @checkout_session = current_user
                        .payment_processor
                        .checkout(
                          mode: 'payment',
                          line_items: @stripe_price_id,
                          success_url: checkout_success_url,
                          cancel_url: checkout_cancel_url,

                        )

  end

  def edit
    @package = Package.find(params[:id])
  end

  def update
    @package = Package.find(params[:id])
    @venue = Venue.find(params[:venue_id])

    if @package.update(item_params)
      redirect_to my_venue_packages_path(@venue)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @package = Package.find(params[:id])
    @package.destroy
    redirect_to dashboard_path(current_user)
  end

  private

  def item_params
    params.require(:package).permit(:package_name, :package_price, :photo, :package_description, :package_duration)
  end
end
