require "test_helper"

class LocationTest < ActiveSupport::TestCase
  test "#address excludes the line2" do
    thoughtbot_nyc = offices(:thoughtbot_nyc)

    address = thoughtbot_nyc.address

    assert_equal address, "1384 Broadway, New York, NY, 10018, US"
  end

  test "#to_coordinates returns the latitude and longitude as a pair" do
    thoughtbot_nyc = offices(:thoughtbot_nyc)

    latitude, longitude = thoughtbot_nyc.to_coordinates

    assert_equal thoughtbot_nyc.latitude, latitude
    assert_equal thoughtbot_nyc.longitude, longitude
  end

  test "#nearby excludes the Location" do
    thoughtbot_nyc = offices(:thoughtbot_nyc)

    nearby = thoughtbot_nyc.nearby

    assert_not_includes nearby, thoughtbot_nyc.location
  end

  test "#nearby returns other Locations" do
    thoughtbot_nyc = offices(:thoughtbot_nyc)
    culture_espresso = cafes(:culture_espresso)
    staten_island_mall = attractions(:staten_island_mall)

    nearby = thoughtbot_nyc.nearby

    assert_includes nearby, culture_espresso.location
    assert_includes nearby, staten_island_mall.location
  end

  test "#nearby accepts a range and unit for filtering" do
    thoughtbot_nyc = offices(:thoughtbot_nyc)
    culture_espresso = cafes(:culture_espresso)
    staten_island_mall = attractions(:staten_island_mall)

    nearby = thoughtbot_nyc.nearby(1, unit: :mi)

    assert_includes nearby, culture_espresso.location
    assert_not_includes nearby, staten_island_mall.location
  end
end
