import { Controller } from "@hotwired/stimulus";
import Sortable from "sortablejs";

export default class extends Controller {
  connect() {
    console.log("Sortable Controller Connected!");

    this.sortable = new Sortable(this.element, {
      animation: 150,
      onEnd: (event) => this.updatePositions(),
    });
  }

  updatePositions() {
    console.log("Updating positions...");

    const images = this.element.querySelectorAll(".form-image-card");

    images.forEach((element, index) => {
      // Ensure there's an input field to update
      let positionInput = element.querySelector("input.photo-position");
      if (positionInput) {
        positionInput.value = index + 1; // Update position
        console.log(`Updated image ${element.dataset.id} to position ${index + 1}`);
      } else {
        console.warn(`No position input found inside #${element.id}`);
      }
    });
  }
}
