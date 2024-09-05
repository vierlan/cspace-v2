class VenuesController < ApplicationController
  def index
    @venues = Venue.all
    @bar_venues = Venue.where(categories: "bar")
    @restaurant_venues = Venue.where(categories: "restaurant")
    @cafe_venues = Venue.where(categories: "cafe")
  end

  def top
  end

  def show
    @user = current_user
    @venue = Venue.find(params[:id])
    @packages = @venue.packages
    @booking = Booking.new
    @venue_owner = @venue.user

  end

  def venue_owner?
    @venue.user == current_user
  end

  def new
    @venue = Venue.new
  end

  def create
    @venue = Venue.new(venue_params)
    @venue.user = current_user
    if @venue.save!
      redirect_to venue_path(@venue)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @venue = Venue.find(params[:id])
  end

  def update
    @venue = Venue.find(params[:id])
    if @venue.update(venue_params)
      redirect_to @venue
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def discovery
    @venues = Venue.where("spaces ->> ? = 'true'", params[:spaces])
    Rails.logger.debug "Venues found: #{@venues.inspect}"
  end



  def destroy
    @venue = Venue.find(params[:id])
    @venue.destroy

    redirect_to venues_path
  end

  private

  #def distance_from_user(@venue)
  #  Geocoder::Calculations.distance_between([@venue.latitude, @venue.longitude], [current_user.latitude, current_user.longitude])
  #end

  def venue_params
    params.require(:venue).permit(:name, :address, :phone, :website, :amenities, :description, :categories, spaces: [:work, :study, :meeting], :photos => [])
  end
end
