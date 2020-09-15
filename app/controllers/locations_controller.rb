class LocationsController < ApplicationController
  def index
    bounding_box = BoundingBox.from_bbox_string(params[:bounds])

    if bounding_box.valid?
      locations = Location.within_bounding_box(*bounding_box)
    else
      locations = Location.near(Current.office, 1, unit: :mi)
      bounding_box = BoundingBox.from_locations(locations)
    end

    render locals: {bounding_box: bounding_box, locations: locations}
  end

  def show
    location = Location.find(params[:id])
    nearby_locations = [ location ] + location.nearby(1, unit: :mi)
    bounding_box = BoundingBox.from_locations(nearby_locations).move_center(location)

    render locals: {location: location, bounding_box: bounding_box}
  end
end
