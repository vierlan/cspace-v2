import { Application } from "@hotwired/stimulus"
import SwiperController from "./swiper_controller"
import ImagePreviewController from "./image_preview_controller"
import HeaderController from "./header_controller"


const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application
application.register("swiper", SwiperController)
application.register("image_preview", ImagePreviewController)
application.register("header", HeaderController);
export { application }
