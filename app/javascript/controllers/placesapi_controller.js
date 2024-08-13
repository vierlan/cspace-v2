import { Controller } from "@hotwired/stimulus"
import { initializeSwiper } from "./swiper_controller"

export default class extends Controller {
  static targets = ["place", "locationButton", "radiusSlider", "resultsContainer"]

  connect() {
    console.log("Stimulus PLACES controller connected")

    // Get the place types from the data attribute
    this.placeTypes = this.element.dataset.placesapiTypes.split(',')

    // Automatically get the user's current location on page load
    this.getCurrentLocation()

    // Initialize Places Autocomplete
    this.initPlaces()

    // Attach event listener for the radius slider
    this.radiusSliderTarget.addEventListener("input", this.updateRadiusValue.bind(this))
    this.radiusValueTarget = document.getElementById("radius-value")
  }

  updateRadiusValue() {
    const radius = this.radiusSliderTarget.value
    this.radiusValueTarget.textContent = radius
  }

  initPlaces() {
    if (typeof google === 'undefined' || !google.maps) {
      console.error("Google Maps JavaScript API is not loaded.")
      return
    }

    const input = this.placeTarget
    const options = {
      types: ['establishment'],
      fields: ['name', 'formatted_address', 'place_id', 'geometry'],
    }

    const autocomplete = new google.maps.places.Autocomplete(input, options)

    autocomplete.addListener('place_changed', () => {
      const place = autocomplete.getPlace()

      if (place.geometry) {
        console.log("Place selected:", place)
        this.fetchPlacesForAllTypes(place.geometry.location)
      } else {
        console.log("No geometry available for this place.")
      }
    })
  }

  getCurrentLocation() {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(
        (position) => {
          const location = {
            lat: position.coords.latitude,
            lng: position.coords.longitude,
          }
          console.log("Current location:", location)
          this.fetchPlacesForAllTypes(location)
        },
        (error) => {
          console.error("Error getting location:", error)
        }
      )
    } else {
      console.error("Geolocation is not supported by this browser.")
    }
  }

  fetchPlacesForAllTypes(location) {
    this.placeTypes.forEach((type, index) => {
      this.findNearbyPlaces(location, type, index)
    })
  }

  findNearbyPlaces(location, type, index) {
    const radius = this.radiusSliderTarget.value
    const service = new google.maps.places.PlacesService(this.placeTarget)

    const request = {
      location: location,
      radius: parseInt(radius),  // Use the value from the slider
      type: [type],
    }

    service.nearbySearch(request, (results, status) => {
      if (status === google.maps.places.PlacesServiceStatus.OK) {
        console.log(`Nearby ${type}s:`, results)

        const resultsContainer = document.getElementById(`results-container-${index}`)
        if (!resultsContainer) {
          console.error(`No results container found for index ${index}`)
          return
        }

        resultsContainer.innerHTML = '' // Clear existing content

        results.slice(0, 10).forEach((place, idx) => {
          const placeDiv = document.createElement('div')
          placeDiv.className = "swiper-slide"
          let photoUrl = ''

          if (place.photos && place.photos.length > 0) {
            photoUrl = place.photos[0].getUrl({ maxWidth: 400 })
          }

          placeDiv.innerHTML = `
              <div class="card-venue-idx" index="${idx}">
                <h3>${place.name}</h3>
                <p>Address: ${place.vicinity}</p>
                <p>Rating: ${place.rating}</p>
                ${photoUrl ? `<img src="${photoUrl}" alt="${place.name}">` : ''}
                <hr />
              </div>
          `
          resultsContainer.appendChild(placeDiv)
        })

        // Initialize Swiper for this container after content is added
        initializeSwiper(`.mySwiper${index}`)
      } else {
        console.error(`Nearby search for ${type} failed:`, status)
      }
    })
  }
}
