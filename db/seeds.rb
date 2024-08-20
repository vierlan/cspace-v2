# db/seeds.rb

require 'open-uri'  # Use open-uri for downloading images
require 'json'
require 'securerandom'

API_KEY = ENV['GOOGLE_API_KEY'] # Fetch the API key from the .env file
LONDON_COORDINATES = '51.5020,-0.4878'
RADIUS = 5000
TYPE = 'restaurant'

Package.destroy_all
Venue.destroy_all
User.destroy_all

# Fetch places from Google Places API
def fetch_places(api_key, location, radius, type)
  url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=#{location}&radius=#{radius}&type=#{type}&key=#{api_key}"
  response = URI.open(url).read
  JSON.parse(response)["results"]
end

# Download the photo using open-uri and return the file path
def download_photo(api_key, photo_reference)
  url = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=#{photo_reference}&key=#{api_key}"
  file_name = "photo_#{SecureRandom.hex}.jpg"
  file_path = Rails.root.join('tmp', file_name)

  File.open(file_path, 'wb') do |file|
    file.write(URI.open(url).read)
  end

  file_path
end

# Create 3 users with random names
users = [

  User.create!(first_name: "John", last_name: "Doe4", email: "john4ed75@example.com", password: "password123", password_confirmation: "password123", venue_owner: true),
  User.create!(first_name: "Jan", last_name: "Smit4h", email: "janwdt56e@example.com", password: "password123", password_confirmation: "password123", venue_owner: true),
  User.create!(first_name: "Alice", last_name: "Johnso4n", email: "aldiecwe55@example.com", password: "password123", password_confirmation: "password123", venue_owner: true),
  User.create!(first_name: "Dev", last_name: "Doe4", email: "Dev@la.la", password: "123123", password_confirmation: "123123", venue_owner: true, admin: true),
  User.create!(first_name: "Lan", last_name: "Anh", email: "la@la.la", password: "123123", password_confirmation: "123123", venue_owner: true, admin: true)
]

# Fetch places from the Google Places API
places =[]
places = fetch_places(API_KEY, LONDON_COORDINATES, RADIUS, TYPE)

  places.each_with_index do |place, index|
    next if place['photos'].nil? || place['photos'].empty?

    user = users[index % users.size]

    # Create a venue with the details from the Google Places API
    venue = Venue.new(
      name: place['name'],
      amenities: "WiFi, Parking", # Example amenities, can be modified
      address: place['vicinity'],  # Fetching and storing the address
      district: "London", # This could be made dynamic if needed
      categories: TYPE,
      latitude: place.dig('geometry', 'location', 'lat'),  # Fetching and storing latitude
      longitude: place.dig('geometry', 'location', 'lng'), # Fetching and storing longitude
      user: user
    )
    if venue.save!
      puts "Venue created successfully!"
    else
      puts "Venue creation failed!"
    end

  # Attach up to 3 photos to the venue
  place['photos'].first(3).each do |photo|
    photo_file_path = download_photo(API_KEY, photo['photo_reference'])

    venue.photos.attach(
      io: File.open(photo_file_path),
      filename: File.basename(photo_file_path),
      content_type: 'image/jpeg'
    )

    # Delete the temporary file after attaching
    File.delete(photo_file_path)
  end
end

puts "Seed data with real places, geolocation, and photos created successfully!"
