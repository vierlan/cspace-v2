import { Controller } from "@hotwired/stimulus"
import Swiper from 'https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.mjs'

// Export the Swiper initialization as a function
export function initializeSwiper(selector) {
  return new Swiper(selector, {
    spaceBetween: 20,
    loop: true,
    centeredSlides: false,
    freeMode: true,
    simulateTouch: true,
    touchRatio: 1,
    touchAngle: 45,
    // Optional: Enable additional touch behaviors
    touchReleaseOnEdges: true,
    threshold: 10, // prevents small unwanted swipe gestures
    // Optional: Prevent long swipes from triggering links
    shortSwipes: false,
    longSwipes: true,
    longSwipesRatio: 0.5,
    longSwipesMs: 300,
    slidesPerView: "auto",
    pagination: {
      el: `${selector} .swiper-pagination`,
      clickable: true,
    },
    navigation: {
      nextEl: `${selector} .swiper-button-next`,
      prevEl: `${selector} .swiper-button-prev`,
    },
  });
}

// If you still want this controller to work independently, keep this part
export default class extends Controller {
  connect() {
    console.log('Hello, Stimulus!', this.element)
    this.swiper = initializeSwiper('.mySwiper');
  }
}
