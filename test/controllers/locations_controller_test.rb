require "test_helper"

class LocationsControllerTest < ActionDispatch::IntegrationTest
  include ActionView::Helpers::TextHelper

  test "#index includes the number of results" do
    thoughtbot_nyc = offices(:thoughtbot_nyc)
    nearby_locations = thoughtbot_nyc.nearby(1, unit: :mi)

    get root_path

    assert_text pluralize(nearby_locations.size + 1, "result")
  end

  test "#index includes information about the Locations' creators" do
    thoughtbot_nyc = offices(:thoughtbot_nyc)

    get root_path

    assert_text thoughtbot_nyc.name
    assert_text thoughtbot_nyc.creator.name
  end

  test "#show includes relevant information" do
    culture_espresso = cafes(:culture_espresso)

    get location_path(culture_espresso.location)

    assert_select "title", text: culture_espresso.name
    assert_text culture_espresso.name
    assert_text culture_espresso.line1
    assert_text culture_espresso.city
    assert_text culture_espresso.state
    assert_text culture_espresso.postal_code
    assert_text culture_espresso.locatable_name.titleize
  end

  test "#show includes information about a Location's creator" do
    thoughtbot_nyc = offices(:thoughtbot_nyc)

    get location_path(thoughtbot_nyc.location)

    assert_text thoughtbot_nyc.name
    assert_text thoughtbot_nyc.creator.name
  end

  test "#show renders other nearby Locations" do
    thoughtbot_nyc = offices(:thoughtbot_nyc)
    culture_espresso = cafes(:culture_espresso)
    staten_island_mall = attractions(:staten_island_mall)

    get location_path(thoughtbot_nyc.location)

    assert_text culture_espresso.name
    assert_no_text staten_island_mall.name
  end

  test "#hides the nearby header when there are no nearby Locations" do
    staten_island_mall = attractions(:staten_island_mall)

    get location_path(staten_island_mall.location)

    assert_select "dt", count: 0, text: "Nearby"
  end
end
