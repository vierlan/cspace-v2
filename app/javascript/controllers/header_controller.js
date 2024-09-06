import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static get targets() {
    return ['mainNav', 'mobileNav', 'nav'];
  };

  connect() {
    console.log("Stimulus header controller connected")
  };

  nav(e) {
    e.preventDefault();
    console.log('toggling spaces nav');
    this.navTarget.classList.toggle('hidden');
  };

  toggleMobileNav() {
    console.log('toggling mobile nav');
    this.mobileNavTarget.classList.toggle('hidden');
  };

  toggleMainNav() {
    console.log('toggling main nav');
    this.mainNavTarget.classList.toggle('hidden');
  };
}
