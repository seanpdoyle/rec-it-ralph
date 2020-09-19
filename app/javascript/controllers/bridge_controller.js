import { Controller } from "stimulus"

export default class extends Controller {
  static values = { attribute: String }

  sendAttribute() {
    const data = this.element.getAttribute(this.attributeValue)

    webkit.messageHandlers.application.postMessage(data)
  }
}
