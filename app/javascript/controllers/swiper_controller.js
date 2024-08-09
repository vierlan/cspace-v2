import { Controller } from "@hotwired/stimulus"
import Swiper from 'https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.mjs'

// Connects to data-controller="swiper"
export default class extends Controller {
  connect() {
    console.log('Hello, Stimulus!', this.element)
    this.swiper = new Swiper('.mySwiper', {
      // Swiper configuration options
      spaceBetween: 10,
      freeMode: true,
      slideperView: "auto",
      pagination: {
        el: ".swiper-pagination",
        clickable: true,
      },
      navigation: {
        nextEl: ".swiper-button-next",
        prevEl: ".swiper-button-prev",
      },
    });
  }
}
