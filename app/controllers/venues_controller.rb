class VenuesController < ApplicationController
  def index
    @venues = Venue.all
    @bar_venues = Venue.where(categories: "bar")
    @restaurant_venues = Venue.where(categories: "restaurant")
    @cafe_venues = Venue.where(categories: "cafe")
    @venue_types = [ @bar_venues, @restaurant_venues, @cafe_venues ]
    @venue_categories = [ "Study!", "Working!", "Meetings" ]
  end

  def show
    @user = current_user
    @venue = Venue.find(params[:id])
    @packages = @venue.packages
    @booking = Booking.new
    @venue_owner = @venue.user
    @venues = [ @venue ]
    @rating = rating(@venue)
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
    @venue.spaces = assign_spaces
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
    @venue.spaces = assign_spaces
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
    params.require(:venue).permit(:name, :address, :phone, :website, :amenities, :claimed, :description, categories: [], spaces: [], photos: [], opening_hours: {})
  end

  def rating(venue)
    # get rating from google places
    api_key = ENV['GOOGLE_PLACES_API_KEY']
    venue_name = URI.encode_www_form_component(venue.name)
    url = "https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=#{venue_name}&inputtype=textquery&fields=rating&key=#{api_key}"
    response = HTTParty.get(url)
    if venue.google_data.present? && venue.google_data["rating"].present?
      return venue.google_data["rating"]
    elsif
      response["candidates"].present? && response["candidates"][0]["rating"].present?
    return response["candidates"][0]["rating"]
    else
      return 0
    end
  end

  def assign_spaces
    @spaces = []
    @spaces << "work" if params[:work] == "true"
    @spaces << "study" if params[:study] == "true"
    @spaces << "meeting" if params[:meeting] == "true"
    @spaces
  end
end
