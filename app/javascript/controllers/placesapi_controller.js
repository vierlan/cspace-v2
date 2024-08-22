// app/javascript/controllers/placesapi_controller.js
import { Controller } from "@hotwired/stimulus"
import { initializeSwiper } from "./swiper_controller"

export default class extends Controller {
  static targets = ["place", "locationButton", "radiusSlider", "resultsContainer", "name"]

  connect() {
    console.log("Stimulus PLACES controller connected")

    // Get the place types from the data attribute
    console.log("Place types:", this.element.dataset.placesapiTypes)
    this.placeTypes = this.element.dataset.placesapiTypes.split(',')
    console.log("Place types:", this.placeTypes)

    // Initialize Places Autocomplete for both search inputs
    if (this.hasPlaceTarget) {
      const scopedTarget = this.targets.find("place")
      console.log("Initializing Places Autocomplete for:", this.placeTarget)
      this.initPlaces(scopedTarget)
      console.log("Initializing Places Autocomplete for scopedTarget:", scopedTarget)
    }

    // Attach event listener for the radius slider if it exists
    if (this.hasRadiusSliderTarget) {
      console.log("Attaching event listener for radius slider:", this.radiusSliderTarget)
      this.radiusSliderTarget.addEventListener("input", this.updateRadiusValue.bind(this))
      this.radiusValueTarget = document.getElementById("radius-value")
    }

    // Automatically get the user's current location if the button exists
    if (this.hasLocationButtonTarget) {
      console.log("Getting current location on page load")
      this.getCurrentLocation()
    }

  }
  changePlace(input) {
    console.log("Changing place")
    this.fetchPlacesForAllTypes(this.placeTarget)
  }



  updateRadiusValue() {
    console.log("Updating radius value")
    const radius = this.radiusSliderTarget.value
    console.log("New radius value:", radius)
    this.radiusValueTarget.textContent = radius
  }

  initPlaces(input) {
    if (typeof google === 'undefined' || !google.maps) {
      console.error("Google Maps JavaScript API is not loaded.")
      return
    }

    const options = {
      types: ['establishment'],
      fields: ['name', 'formatted_address', 'place_id', 'geometry'],
    }

    const autocomplete = new google.maps.places.Autocomplete(input, options)

    autocomplete.addListener('place_changed', () => {
      debugger
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
    console.log("Finding nearby places of type:", type, "within radius:", radius)

    const service = new google.maps.places.PlacesService(this.placeTarget)

    const request = {
      location: location,
      radius: parseInt(radius),
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
              ${photoUrl ? `<img src="${photoUrl}" alt="${place.name}">` : ''}
                <h2>${place.name}</h2>
                <p>Address: ${place.vicinity}</p>
                <p>Rating: ${place.rating}</p>

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
