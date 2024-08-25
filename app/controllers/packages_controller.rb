class PackagesController < ApplicationController
  def new
    @package = Package.new
    @venue = Venue.find(params[:venue_id])
  end

  def create
    @package = Package.new(item_params)
    @package.venue_id = params[:venue_id]
    @venue = Venue.find(params[:venue_id])
    Stripe.api_key = ENV['STRIPE_SECRET_KEY']
    
    if @package.save
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
