import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "template" ]
  static values = {
    center: Array,
    configuration: Object,
    geoJson: Object,
  }

  connect() {
    const {
      element,
      centerValues,
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
    this.map.fitBounds(geoJsonLayer.getBounds())

    if (centerValues.length) {
      this.map.panTo(centerValues, { animate: false })
    }
  }
}
