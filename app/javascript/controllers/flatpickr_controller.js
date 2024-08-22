import { Controller } from "@hotwired/stimulus"


// Connects to data-controller="flatpickr"
export default class extends Controller {
  static targets = [ "bookingDate", "bookingStartTime" ]

  connect() {
    console.log("Stimulus FLATPICKR controller connected", flatpickr)
    flatpickr(this.bookingDateTarget, {})
    flatpickr(this.bookingStartTimeTarget, {enableTime: true, noCalendar: true, dateFormat: "H:i"})
  }
}
