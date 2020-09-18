import { Controller } from "stimulus"

export default class extends Controller {
  static classes = [ "active" ]
  static targets = [ "draggable" ]
  static values = { maximumHeight: Number, offsetHeight: Number }

  offsetHeightValueChanged(offsetHeight) {
    if (offsetHeight) {
      this.element.style.setProperty("--top-offset", `${offsetHeight}vh`)
    }
  }

  activate({ currentTarget } ) {
    if (this.hasActiveClass) currentTarget.classList.add(this.activeClass)
  }

  drag(event) {
    event.preventDefault()

    const [ latestTouch ] = event.changedTouches
    const { height } = window.visualViewport
    const offsetPercent = latestTouch.pageY / height
    const minimumPercent = this.element.parentElement.offsetTop / height
    const minimumHeightValue = Math.max(offsetPercent, minimumPercent) * 100

    this.offsetHeightValue = Math.min(minimumHeightValue, this.maximumHeightValue)
  }

  deactivate({ currentTarget } ) {
    if (this.hasActiveClass) currentTarget.classList.remove(this.activeClass)
  }
}
