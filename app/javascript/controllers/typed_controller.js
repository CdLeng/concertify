import { Controller } from "@hotwired/stimulus"
import Typed from 'typed.js';


// Connects to data-controller="typed"
export default class extends Controller {
  static values = {
    artists: Array
  }

  static targets = ["typed"]

  connect() {
    console.log(this.artistsValue)
    console.log(this.typedTarget)
    this.typed = new Typed(this.typedTarget, {
      strings: this.artistsValue,
      typeSpeed: 30,
      backSpeed: 30,
      smartBackspace: true,
    })
  }

  disconnect() {
    this.typed.destroy
  }
}
