import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="spaces"
export default class extends Controller {
  static targets = ['space'];
  connect() {
    console.log("Stimulus spaces controller connected")
  }

  // Toggles the hidden class on the space element
  space() {
    console.log('toggling space');
    this.spaceTarget.classList.toggle('hidden');
  }
}
