import { Controller } from "stimulus"

export default class extends Controller {
  static classes = [ "hidden" ]

  updateBounds(event) {
    const map = event.detail.target
    const bounds = map.getBounds()

    this.element.elements.bounds.value = bounds.toBBoxString()
  }

  showSubmit() {
    this.element.elements.submit.classList.remove(this.hiddenClass)
  }

  hideSubmit() {
    this.element.elements.submit.classList.add(this.hiddenClass)
  }
}
