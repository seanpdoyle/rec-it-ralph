require "test_helper"

class BoundingBoxTest < ActiveSupport::TestCase
  test ".from_bbox_string parses the values in the correct order" do
    bbox_string = "100.23,40.71,88.65,36.12"

    bounding_box = BoundingBox.from_bbox_string(bbox_string)

    assert_equal_coordinates [40.71, 100.23], [36.12, 88.65], bounding_box
  end

  test ".from_locations determines the bounds" do
    staten_island = attractions(:staten_island_mall)
    manhattan = offices(:thoughtbot_nyc)
    queens = cafes(:gossip_coffee)

    bounding_box = BoundingBox.from_locations([staten_island, queens])
    south_west, north_east = bounding_box.to_coordinates

    assert_equal [staten_island.latitude, staten_island.longitude], south_west
    assert_equal [queens.latitude, queens.longitude], north_east
  end

  test ".from_locations with a single Location calculates the bounds" do
    thoughtbot_nyc = offices(:thoughtbot_nyc)

    bounding_box = BoundingBox.from_locations([thoughtbot_nyc])
    south_west, north_east = bounding_box.to_coordinates

    assert_equal [thoughtbot_nyc.latitude, thoughtbot_nyc.longitude], south_west
    assert_equal [thoughtbot_nyc.latitude, thoughtbot_nyc.longitude], north_east
  end

  test "#to_bbox serializes the values in the correct order" do
    bounding_box = BoundingBox.from_bounds([40.74, -73.98], [40.75, -73.97])

    bbox = bounding_box.to_bbox

    assert_equal [-73.98, 40.74, -73.97, 40.75], bbox
  end

  test "#move_center returns a bounding box with that point at its center" do
    box = BoundingBox.from_bounds([10.0, 10.0], [30.0, 30.0])
    location = OpenStruct.new(to_coordinates: [-5.0, 5.0])

    assert_equal_coordinates [5.0, 5.0], [25.0, 25.0], box.move_center([15.0, 15.0])
    assert_equal_coordinates [15.0, 15.0], [35.0, 35.0], box.move_center([25.0, 25.0])
    assert_equal_coordinates [-35.0, -35.0], [-15.0, -15.0], box.move_center([-25.0, -25.0])
    assert_equal_coordinates [-15.0, -5.0], [5.0, 15.0], box.move_center(location)
  end

  test "is invalid when built with an empty locations value" do
    bounding_box = BoundingBox.from_locations([])

    assert_not_predicate bounding_box, :valid?
  end

  test "is invalid when built with an empty bbox_string" do
    bounding_box = BoundingBox.from_bbox_string("")

    assert_not_predicate bounding_box, :valid?
  end

  test "is invalid when built with an invalid bbox_string" do
    bounding_box = BoundingBox.from_bbox_string("junk,junk,junk,junk")

    assert_not_predicate bounding_box, :valid?
  end

  test "is invalid when latitudes are out of bounds" do
    assert_not_predicate BoundingBox.from_bounds([91, 0], [0, 0]), :valid?
    assert_not_predicate BoundingBox.from_bounds([-91, 0], [0, 0]), :valid?
    assert_not_predicate BoundingBox.from_bounds([0, 0], [0, 91]), :valid?
    assert_not_predicate BoundingBox.from_bounds([0, 0], [0, -91]), :valid?
  end

  test "is invalid when longitudes are out of bounds" do
    assert_not_predicate BoundingBox.from_bounds([0, 181], [0, 0]), :valid?
    assert_not_predicate BoundingBox.from_bounds([0, -181], [0, 0]), :valid?
    assert_not_predicate BoundingBox.from_bounds([0, 0], [181, 0]), :valid?
    assert_not_predicate BoundingBox.from_bounds([0, 0], [-181, 0]), :valid?
  end

  test "is invalid when south is greater than north" do
    assert_not_predicate BoundingBox.from_bounds([50, 0], [40, 0]), :valid?
  end

  test "is invalid when east is less than west" do
    assert_not_predicate BoundingBox.from_bounds([0, 50], [40, 0]), :valid?
  end

  def assert_equal_coordinates(south_west, north_east, location)
    assert_equal [ south_west, north_east ], location.to_coordinates
  end
end
