import { Controller } from "stimulus"

export default class extends Controller {
  static values = {
    attribute: String,
    name: String,
  }

  connect() {
    const elementStyles = window.getComputedStyle(this.element)
    const documentStyles = document.documentElement.style
    const { nameValue, attributeValue } = this

    documentStyles.setProperty(nameValue, elementStyles[attributeValue])
  }
}
