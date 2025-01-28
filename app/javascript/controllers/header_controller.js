import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static get targets() {
    return ["mainNav", "mobileNav", "nav"];
  }

  connect() {
    console.log("Stimulus header controller connected");
    // Ensure navigation menus are hidden on page load
    if (this.hasMainNavTarget) {
      this.mainNavTarget.classList.add("hidden");
    }
    if (this.hasMobileNavTarget) {
      this.mobileNavTarget.classList.add("hidden");
    }
  }

  toggleMobileNav() {
    console.log("Toggling mobile nav");
    if (this.hasMobileNavTarget) {
      this.mobileNavTarget.classList.toggle("hidden");
    }
  }

  toggleMainNav() {
    console.log("Toggling main nav");
    if (this.hasMainNavTarget) {
      this.mainNavTarget.classList.toggle("hidden");
    }
  }

  nav(e) {
    e.preventDefault();
    console.log("Toggling spaces nav");
    if (this.hasNavTarget) {
      this.navTarget.classList.toggle("hidden");
    }
  }
}
