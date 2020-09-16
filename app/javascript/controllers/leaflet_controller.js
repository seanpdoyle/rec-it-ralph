import { Controller } from "stimulus"

export default class extends Controller {
  static values = {
    configuration: Object,
    initialized: Boolean,
    templateSelector: String,
  }

  initialize() {
    this.dispatchEvent = this.dispatchEvent.bind(this)
  }

  connect() {
    const {
      element,
      configurationValue,
      initializedValue,
      geoJsonValue,
      templateTarget,
    } = this
    const { animate, templateUrl, ...options } = configurationValue

    this.map = this.map || L.map(element, {
      layers: [ L.tileLayer(templateUrl, options) ]
    })

    const geoJsonLayer = L.geoJSON(geoJsonValue, {
      pointToLayer: ({ properties }, latLng) => {
        const template = templateTarget.content.getElementById(properties.iconId)
        const icon = L.divIcon({ html: template.outerHTML, className: null })

        return L.marker(latLng, { icon })
      }
    })

    this.map.addLayer(geoJsonLayer)

    if (geoJsonValue?.bbox) {
      const [ west, south, east, north ] = geoJsonValue.bbox
      const bounds = L.latLngBounds([ south, west ], [ north, east ])

      initializedValue ?
        this.map.flyToBounds(bounds, { animate }) :
        this.map.fitBounds(bounds, { animate: false })
    }

    this.map.on("movestart", this.dispatchEvent)
    this.map.on("moveend", this.dispatchEvent)

    this.initializedValue = true
  }

  disconnect() {
    const layers = []

    this.map.eachLayer(layer => layers.push(layer))

    const [ tileLayer, ...otherLayers ] = layers

    otherLayers.forEach(layer => this.map.removeLayer(layer))

    this.map.off("movestart", this.dispatchEvent)
    this.map.off("moveend", this.dispatchEvent)
  }

  get templateTarget() {
    return document.querySelector(this.templateSelectorValue)
  }

  get geoJsonValue() {
    const attributeName = `data-${this.identifier}-geo-json-value`

    return JSON.parse(this.templateTarget.getAttribute(attributeName)) || {}
  }

  dispatchEvent(detail, { bubbles = true, cancelable = true } = {}) {
    const type = `${this.identifier}:${detail.type}`
    const customEvent = new CustomEvent(type, { detail, bubbles, cancelable })

    document.dispatchEvent(customEvent)
  }
}
