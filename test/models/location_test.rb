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
end
