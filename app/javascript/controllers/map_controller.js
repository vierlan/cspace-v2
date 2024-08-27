import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="map"
export default class extends Controller {
  static targets = ['map',"venues"]

  connect() {
    console.log('Map controller connected');
    this.initGoogle();

  }


  initGoogle() {
    console.log('Initializing Google Maps');
  const myLatlng = { lat: 51.657, lng: -0.4878 };
  const map = new google.maps.Map(this.mapTarget, {
    center: myLatlng,
    zoom: 10,
  });
  this.addMarkers(map);
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
