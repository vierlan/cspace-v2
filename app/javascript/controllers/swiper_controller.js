import { Controller } from "@hotwired/stimulus"
import Swiper from 'https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.mjs'

// Export the Swiper initialization as a function
export function initializeSwiper(selector) {
  return new Swiper(selector, {
    spaceBetween: 10,
    loop: false,
    centeredSlides: false,
    freeMode: false,
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