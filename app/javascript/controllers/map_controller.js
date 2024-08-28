import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="map"
export default class extends Controller {
  static targets = ['map', "venues", "showMap", "hideMap", "venueList", "showList", "hideList"]

  connect() {
    console.log('Map controller connected');
    this.initGoogle();

  }


  showList(e) {
    e.preventDefault();
    console.log('showing list');
    this.venueListTarget.classList.remove('hidden');
    this.showListTarget.classList.add('hidden');
    this.hideListTarget.classList.remove('hidden');
  }

  hideList(e) {
    e.preventDefault();
    console.log('hiding list');
    this.venueListTarget.classList.add('hidden');
    this.showListTarget.classList.remove('hidden');
    this.hideListTarget.classList.add('hidden');
  }

  showMap(e) {
    e.preventDefault();
    console.log('showing map');
    this.mapTarget.classList.remove('hidden');
    this.showMapTarget.classList.add('hidden');
    this.hideMapTarget.classList.remove('hidden');
  }

  hideMap(e) {
    e.preventDefault
    console.log('hiding map');
    this.hideMapTarget.classList.add('hidden');
    this.showMapTarget.classList.remove('hidden');
    this.mapTarget.classList.add('hidden');
  }

  initGoogle() {
    console.log('Initializing Google Maps');
    const myLatlng = { lat: 51.657, lng: -0.4878 };
    const map = new google.maps.Map(this.mapTarget, {
    center: myLatlng,
    zoom: 10,
  });
  this.addMarkers(map);
  this.fitBounds(map);
}

fitBounds(map) {
  const bounds = new google.maps.LatLngBounds();
  Array.from(this.venuesTarget.children).forEach((venue) => {
    const lat = parseFloat(venue.dataset.lat);
    const lng = parseFloat(venue.dataset.lng);
    if (!isNaN(lat) && !isNaN(lng)) {
      bounds.extend({ lat, lng });
      console.log(`Added to bounds: lat=${lat}, lng=${lng}`);
    } else {
      console.warn(`Invalid lat/lng for venue: ${venue}`);
    }
  });

  if (!bounds.isEmpty()) {
    map.fitBounds(bounds);
    console.log('Bounds set on map:', bounds);
  } else {
    console.warn('No valid venues to fit bounds.');
  }
}
  addMarkers(map) {
   Array.from(this.venuesTarget.children).forEach((venue) => {
    if(venue.dataset.lat && venue.dataset.lng) {
      this.addMarker(venue, map);
    }
  }
  );
  };

  addMarker(venue, map) {

    new google.maps.Marker({
      position: {
        lat: parseFloat(venue.dataset.lat),
        lng: parseFloat(venue.dataset.lng)
      },
      map,
      title: venue.dataset.title,

    });
  }

}
