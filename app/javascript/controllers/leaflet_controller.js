import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "template" ]
  static values = {
    configuration: Object,
    geoJson: Object,
  }

  initialize() {
    this.dispatchEvent = this.dispatchEvent.bind(this)
  }

  connect() {
    const {
      element,
      configurationValue,
      geoJsonValue,
      templateTarget,
    } = this
    const { templateUrl, ...options } = configurationValue

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

      this.map.fitBounds(bounds, { animate: false })
    }

    this.map.on("movestart", this.dispatchEvent)
    this.map.on("moveend", this.dispatchEvent)
  }

  disconnect() {
    this.map.off("movestart", this.dispatchEvent)
    this.map.off("moveend", this.dispatchEvent)
  }

  dispatchEvent(detail, { bubbles = true, cancelable = true } = {}) {
    const type = `${this.identifier}:${detail.type}`
    const customEvent = new CustomEvent(type, { detail, bubbles, cancelable })

    document.dispatchEvent(customEvent)
  }
}
