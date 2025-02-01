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
    @venue.spaces = assign_spaces

    if params[:venue][:assign_to_user] == "1" && params[:venue][:user_email].present?
      user_email = params[:venue][:user_email].strip.downcase
      user = User.find_by(email: user_email)

      unless user
        # No user found with that email
        @venue.errors.add(:user_email, "No user found with email #{user_email}")
        return render :new, status: :unprocessable_entity
      end

      # If user is found, assign the venue
      @venue.user = user
      @venue.claimed = true
    else # If the venue is not assigned to a user, assign it to the current user
      @venue.user = current_user
      @venue.claimed = false
    end


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

        # If new media files are uploaded, append them; don't replace the old ones.
        if venue_params[:photos]
          @venue.photos.attach(venue_params[:photos])
        end

        # Handle photos reordering if provided
        if params[:venue][:photo_positions].present?
          params[:venue][:photo_positions].each_with_index do |photo_id, index|
            photo = @venue.photos.find(photo_id) rescue nil
            photo&.update(position: index + 1) # Assuming `position` column exists in your ActiveStorage metadata
          end
        end
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

  def move_media
    #Find the venue who's images we are re-arranging
    @venue = Venue.find(params[:id])
    #Find the image we are moving
    @image = @venue.images[params[:old_position].to_i - 1]
    # Use the insert_at method we get from acts_as_list gem
    @image.insert_at(params[:new_position].to_i)
    head :ok
  end

  def remove_photos
    @venue = Venue.find(params[:id])
    photos = @venue.photos.find(params[:photos_id])
    media_id = photos.id
    photos.purge

    respond_to do |format|
      format.html { redirect_to edit_venue_path(@venue), notice: 'Media removed successfully.' }
      format.turbo_stream { render turbo_stream: turbo_stream.remove("media_#{media_id}") }
    end
  end


  private

  #def distance_from_user(@venue)
  #  Geocoder::Calculations.distance_between([@venue.latitude, @venue.longitude], [current_user.latitude, current_user.longitude])
  #end

  def venue_params
    params.require(:venue).permit(:name, :address, :assign_to_user, :user_email, :phone, :website, :amenities, :claimed, :description, :categories, spaces: [], photos: [],  videos: [], opening_hours: {})
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
