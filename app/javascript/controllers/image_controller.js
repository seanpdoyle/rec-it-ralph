import { Controller } from "stimulus"

export default class extends Controller {
  static values = { fallback: String }

  connect() {
    this.element.addEventListener("error", this.loadDefault)
  }

  disconnect() {
    this.element.removeEventListener("error", this.loadDefault)
  }

  loadDefault = ({ target }) => {
    target.src = this.fallbackValue

    this.element.removeEventListener("element", this.loadDefault)
  }
}
