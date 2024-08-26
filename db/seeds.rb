# db/seeds.rb

require 'open-uri'  # Use open-uri for downloading images
require 'json'
require 'securerandom'

API_KEY = ENV['GOOGLE_API_KEY'] # Fetch the API key from the .env file
LONDON_COORDINATES = '51.5020,-0.4878'
RADIUS = 5000
TYPE = 'restaurant'
def destroy_all
  Booking.destroy_all
  Package.destroy_all
  Venue.destroy_all
  User.destroy_all
end

# Fetch places from Google Places API
def fetch_places(api_key, location, radius, type)
  url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=#{location}&radius=#{radius}&type=#{type}&key=#{api_key}"
  response = URI.open(url).read
  return JSON.parse(response)["results"]
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

# Create 5 users with random names
def create_users
  puts "Creating users..."
  users = [
    User.create!(first_name: "John", last_name: "Doe4", email: "john4ed75@example.com", password: "password123", password_confirmation: "password123", venue_owner: true),
    User.create!(first_name: "Jan", last_name: "Smit4h", email: "janwdt56e@example.com", password: "password123", password_confirmation: "password123", venue_owner: true),
    User.create!(first_name: "Alice", last_name: "Johnso4n", email: "aldiecwe55@example.com", password: "password123", password_confirmation: "password123", venue_owner: true),
    User.create!(first_name: "Dev", last_name: "Doe4", email: "Dev@la.la", password: "123123", password_confirmation: "123123", venue_owner: true, admin: true),
    User.create!(first_name: "Lan", last_name: "Anh", email: "la@la.la", password: "123123", password_confirmation: "123123", venue_owner: true, admin: true)
  ]
  return users
end

# Fetch places from the Google Places API
def create_places(api_key, location, radius, type, users)
  puts "Fetching places..."
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
      attach_photos(venue, place)
    else
      puts "Venue creation failed!"
    end
  end
end

  # Attach up to 3 photos to the venue
def attach_photos(venue, place)
  puts "Attaching photos..."
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
def seed_packages
  package_photos = [[
    'https://plus.unsplash.com/premium_photo-1676106623583-e68dd66683e3?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://plus.unsplash.com/premium_photo-1672363353897-ae5a81a1ab57?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8YnJlYWtmYXN0fGVufDB8fDB8fHww',
    'https://images.unsplash.com/photo-1504708706948-13d6cbba4062?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8YnJlYWtmYXN0fGVufDB8fDB8fHww',
    'https://images.unsplash.com/photo-1464306208223-e0b4495a5553?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8YnJlYWtmYXN0fGVufDB8fDB8fHww',
    'https://images.unsplash.com/photo-1528699633788-424224dc89b5?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8YnJlYWtmYXN0fGVufDB8fDB8fHww',
    'https://images.unsplash.com/photo-1493770348161-369560ae357d?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OHx8YnJlYWtmYXN0fGVufDB8fDB8fHww'
  ],

  [
    'https://plus.unsplash.com/premium_photo-1663840277579-ff6147963ce7?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NXx8YnJlYWtmYXN0fGVufDB8fDB8fHww',
    'https://images.unsplash.com/photo-1465014925804-7b9ede58d0d7?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8N3x8YnJlYWtmYXN0fGVufDB8fDB8fHww',
    'https://plus.unsplash.com/premium_photo-1676106623583-e68dd66683e3?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OXx8YnJlYWtmYXN0fGVufDB8fDB8fHww',
    'https://images.unsplash.com/photo-1501959915551-4e8d30928317?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTF8fGJyZWFrZmFzdHxlbnwwfHwwfHx8MA%3D%3D',
    'https://plus.unsplash.com/premium_photo-1661667100338-4e9bdf34ceef?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTN8fGJyZWFrZmFzdHxlbnwwfHwwfHx8MA%3D%3D',
    'https://images.unsplash.com/photo-1499638309848-e9968540da83?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTV8fGJyZWFrZmFzdHxlbnwwfHwwfHx8MA%3D%3D',
    'https://plus.unsplash.com/premium_photo-1663013644564-f34ba6d12144?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTd8fGJyZWFrZmFzdHxlbnwwfHwwfHx8MA%3D%3D'
  ],
    [
    'https://images.unsplash.com/photo-1491273289208-9340cb42e5d9?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTh8fGJyZWFrZmFzdHxlbnwwfHwwfHx8MA%3D%3D',
    'https://images.unsplash.com/photo-1475855664010-a869729f42c3?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjB8fGJyZWFrZmFzdHxlbnwwfHwwfHx8MA%3D%3D',
    'https://images.unsplash.com/photo-1627662236973-4fd8358fa206?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTJ8fGx1bmNofGVufDB8fDB8fHww',
    'https://plus.unsplash.com/premium_photo-1674147611133-be87db07f597?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTN8fGx1bmNofGVufDB8fDB8fHww',
    'https://plus.unsplash.com/premium_photo-1701113208672-df1d083413d9?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTd8fGx1bmNofGVufDB8fDB8fHww',
    'https://images.unsplash.com/photo-1634128222851-7e62b3ef2680?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8d29ya2luZyUyMGx1bmNofGVufDB8fDB8fHww',
    'https://plus.unsplash.com/premium_photo-1700583712179-cf321f08fe99?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OXx8d29ya2luZyUyMGx1bmNofGVufDB8fDB8fHww'
    ]]


  puts "Seeding packages..."
  venues = Venue.all
  venues.each do |venue|
    3.times do |i|
      package = venue.packages.new(
        package_name: "Package #{i + 1}",
        package_price: rand(9..99),
        package_description: "This is package #{i + 1}",
        package_duration: rand(1..5),
        venue_id: venue.id
      )
      if package.save!
        puts "attaching photo to package"
        photo = package_photos[i].sample
        add_package_photo(package, photo)
      else
        puts "Package creation failed!"
      end
    end
  end
end

def add_package_photo(package, photo)
  package.photo.attach(io: URI.open(photo), filename: "photo_#{SecureRandom.hex}.jpg")
end



def run_seed
  destroy_all
  users = create_users
  create_places(API_KEY, LONDON_COORDINATES, RADIUS, TYPE, users)
  packages = seed_packages
  puts "Seed completed!"
end

run_seed
