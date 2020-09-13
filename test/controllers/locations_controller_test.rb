require "test_helper"

class LocationsControllerTest < ActionDispatch::IntegrationTest
  test "#index includes the number of results" do
    get root_path

    assert_text /\d+ results/
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
end
