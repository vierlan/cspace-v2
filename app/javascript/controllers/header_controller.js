import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static get targets() {
    return ['mainNav', 'mobileNav', 'spacesNav'];
  }
  connect() {
    console.log("Stimulus header controller connected")
  }

  toggleMobileNav() {
    console.log('toggling mobile nav');
    this.mobileNavTarget.classList.toggle('hidden');
  }

  toggleMainNav() {
    console .log('toggling main nav');
    this.mainNavTarget.classList.toggle('hidden');
  }

  toggleSpacesNav() {
    console.log('toggling spaces nav');
    this.spacesNavTarget.classList.toggle('hidden');
  }
}
