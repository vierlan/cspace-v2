# app/helpers/venues_helper.rb
module VenuesHelper
  # Define a hash mapping facility names to icon classes (e.g., Font Awesome)
  FACILITY_ICONS = {
    "WiFi" => "fa-solid fa-wifi",
    "Parking" => "fa-solid fa-car",
    "dog_friendly" => "fa-solid fa-dog",
    "air_conditioning" => "fa-regular fa-snowflake",
    "alcohol" => "fa-solid fa-wine-glass",
    "food" => "fa-solid fa-utensils",
    "vegan" => "fa-solid fa-carrot",
    "vegetarian" => "fa-solid fa-leaf",
    "gluten_free" => "fa-solid fa-bread-slice",
    "dairy_free" => "fa-solid fa-cheese",
    "halal" => "fa-solid fa-mosque",
    "kosher" => "fa-solid fa-star-of-david",
    "child_friendly" => "fa-solid fa-child",
    "disabled_access" => "fa-solid fa-wheelchair",
    "quiet" => "fa-solid fa-volume-mute",
    "outdoor_seating" => "fa-solid fa-umbrella-beach",
    "smoking_area" => "fa-solid fa-smoking",
    "bike_parking" => "fa-solid fa-bicycle",
    "great coffee" => "fa-solid fa-mug-hot",

  }

  # Method to render icons based on the amenities available at a venue
  def facility_icons(venue)
    return if venue.amenities.blank?

    # Split the amenities string, strip whitespace, and map them to icons
    amenities = venue.amenities.split(',').map(&:strip)
    amenities.map do |facility|
      icon_class = FACILITY_ICONS[facility]
      icon_class ? "<i class='#{icon_class} mr-2'></i>".html_safe : facility
    end.join(' ').html_safe
  end
end
