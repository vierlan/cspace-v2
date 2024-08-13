import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["place"]

  connect() {
    console.log("Stimulus PLACES controller connected");
    this.initPlaces();
  }

  initPlaces() {
    if (typeof google === 'undefined' || !google.maps) {
      console.error("Google Maps JavaScript API is not loaded.");
      return;
    }

    const input = this.placeTarget;
    const options = {
      types: ['establishment'],
      fields: ['name', 'formatted_address', 'place_id', 'geometry'],
    };

    const autocomplete = new google.maps.places.Autocomplete(input, options);

    autocomplete.addListener('place_changed', () => {
      const place = autocomplete.getPlace();

      if (place.geometry) {
        console.log("Place selected:", place);
        this.findNearbyRestaurants(place.geometry.location);
      } else {
        console.log("No geometry available for this place.");
      }
    });
  }

  findNearbyRestaurants(location) {
    const service = new google.maps.places.PlacesService(this.placeTarget);

    const request = {
      location: location,
      radius: 1000,  // 1km radius
      type: ['restaurant'],
    };

    service.nearbySearch(request, (results, status) => {
      if (status === google.maps.places.PlacesServiceStatus.OK) {
        console.log("Nearby restaurants:", results);
        
        // Assuming there is a div with id="results-container" in your HTML
        const resultsContainer = document.getElementById('results-container');
        resultsContainer.innerHTML = ''; // Clear existing content
        
        results.forEach((restaurant, index) => {
          const restaurantDiv = document.createElement('div');
          restaurantDiv.className="swiper-slide"
          let photoUrl = '';

          // Check if the restaurant has photos and get the first one
          if (restaurant.photos && restaurant.photos.length > 0) {
            photoUrl = restaurant.photos[0].getUrl({ maxWidth: 400 });
          }

          restaurantDiv.innerHTML = `
              <div class="card-venue-idx" index="${index}">
                <h3>${restaurant.name}</h3>
                <p>Address: ${restaurant.vicinity}</p>
                <p>Rating: ${restaurant.rating}</p>
                ${photoUrl ? `<img src="${photoUrl}" alt="${restaurant.name}">` : ''}
                <hr />
              </div>
          `;
          resultsContainer.appendChild(restaurantDiv);
        });
      } else {
        console.error("Nearby search failed:", status);
      }
    });
  }
}
