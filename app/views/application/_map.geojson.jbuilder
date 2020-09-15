bounding_box ||= BoundingBox.from_locations(locations)

json.type "FeatureCollection"
json.bbox bounding_box.to_bbox
json.features locations, partial: "locations/location", as: :location
