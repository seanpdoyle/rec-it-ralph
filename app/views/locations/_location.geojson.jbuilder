json.type "Feature"
json.properties do
  json.iconId dom_id(location, :marker)
  json.url location_url(location)
end
json.geometry do
  json.type "Point"
  json.coordinates [ location.longitude, location.latitude ]
end
