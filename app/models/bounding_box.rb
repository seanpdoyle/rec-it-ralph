class BoundingBox
  include ActiveModel::Model
  include ActiveModel::Validations
  include ActiveModel::Attributes

  attribute :north, :float
  attribute :south, :float
  attribute :east, :float
  attribute :west, :float

  validates :north, :south, inclusion: -90...90
  validates :east, :west, inclusion: -180...180
  validate { errors.add(:west) if west.to_f >= east.to_f }
  validate { errors.add(:south) if south.to_f >= north.to_f }

  def self.from_bbox_string(bounds)
    west, south, east, north = bounds.to_s.split(",")

    from_bounds([south, west], [north, east])
  end

  def self.from_locations(locations)
    if locations.one?
      bounds = locations.first.to_coordinates

      from_bounds(bounds, bounds)
    else
      latitudes = locations.map(&:latitude)
      longitudes = locations.map(&:longitude)

      from_bounds(
        [latitudes.min, longitudes.min],
        [latitudes.max, longitudes.max]
      )
    end
  end

  def self.from_bounds(south_west, north_east)
    south, west = south_west
    north, east = north_east

    new(south: south, west: west, north: north, east: east)
  end

  def move_center(destination)
    new_latitude, new_longitude = destination.respond_to?(:to_coordinates) ?
      destination.to_coordinates :
      destination

    latitude, longitude = center
    rise = new_latitude - latitude
    run = new_longitude - longitude

    BoundingBox.from_bounds(
      [ south + rise, west + run ],
      [ north + rise, east + run ]
    )
  end

  def center
    [
      [ south, north ].sum / 2.0,
      [ east, west ].sum / 2.0,
    ]
  end

  def to_param
    [ west, south, east, north ].join(",")
  end

  def to_bbox
    [ west, south, east, north ]
  end

  def to_coordinates
    [
      [ south, west ],
      [ north, east ],
    ]
  end

  def to_a
    to_coordinates
  end
end
