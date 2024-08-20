import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input", "preview", "dropZone"];

  connect() {
    this.previewExistingImage();
  };

  previewExistingImage() {
    console.log("previewExistingImage");
    if (this.previewTarget.dataset.url) {
      this.previewTarget.src = this.previewTarget.dataset.url;
      this.previewTarget.classList.remove("hidden");
    };
  };

  previewImage(event) {
    console.log("Preview image function triggered");

    const file = this.inputTarget.files[0];
    if (file) {
      console.log("File found:", file.name);
      const reader = new FileReader();

      reader.onloadend = () => {
        console.log("FileReader result:", reader.result); // Check if the result is correct
        this.previewTarget.src = reader.result;
        this.previewTarget.classList.remove("hidden");
        console.log("Image preview updated");
      };

      reader.readAsDataURL(file);
    } else {
      console.log("No file found");
    }
  }


  handleDragOver(event) {
    console.log("Drag over");
    event.preventDefault();
    this.dropZoneTarget.classList.add("bg-gray-100");
  };

  handleDragLeave(event) {
    console.log("Drag leave");
    event.preventDefault();
    this.dropZoneTarget.classList.remove("bg-gray-100");
  };

  handleDrop(event) {
    console.log("Drop");
    event.preventDefault();
    this.dropZoneTarget.classList.remove("bg-gray-100");

    const files = event.dataTransfer.files;
    if (files.length > 0) {
      this.inputTarget.files = files;
      this.inputTarget.dispatchEvent(new Event("change"));
    };
  };
}
