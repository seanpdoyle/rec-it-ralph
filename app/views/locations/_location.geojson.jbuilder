json.type "Feature"
json.properties do
  json.iconId dom_id(location, :marker)
end
json.geometry do
  json.type "Point"
  json.coordinates [ location.longitude, location.latitude ]
end
