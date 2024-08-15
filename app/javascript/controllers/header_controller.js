import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static get targets() {
    return ['mainNav', 'mobileNav'];
  }
  connect() {
    console.log("Stimulus header controller connected")
  }

  toggleMobileNav() {
    this.mobileNavTarget.classList.toggle('hidden');
  }

  toggleMainNav() {
    this.mainNavTarget.classList.toggle('hidden');
  }
}
