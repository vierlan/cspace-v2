import { Controller } from "@hotwired/stimulus";
import flatpickr from "flatpickr";

// Connects to data-controller="flatpickr"
export default class extends Controller {
  static targets = ["bookingDate", "bookingStartTime"];

  connect() {
    console.log("Stimulus FLATPICKR controller connected", flatpickr);

    flatpickr(this.bookingDateTarget, {
      minDate: "today",
      maxDate: new Date().fp_incr(14),
      dateFormat: "d-m-Y",
    });

    flatpickr(this.bookingStartTimeTarget, {
      enableTime: true,
      noCalendar: true,
      dateFormat: "H:i",
      minuteIncrement: 5,
      minTime: "06:00",
      maxTime: "22:00",
      onReady: function(selectedDates, dateStr, instance) {
        console.log("Flatpickr initialized with minuteIncrement: 15");
      },
    });
  }
}
