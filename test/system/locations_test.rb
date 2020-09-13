require "application_system_test_case"

class LocationsTest < ApplicationSystemTestCase
  test "view Cafes near thoughtbot NYC" do
    thoughtbot_nyc = offices(:thoughtbot_nyc)
    culture_espresso = cafes(:culture_espresso)

    visit root_path

    assert_text thoughtbot_nyc.name
    assert_text culture_espresso.name
  end

  test "views a Location" do
    culture_espresso = cafes(:culture_espresso)

    visit root_path
    click_on culture_espresso.name

    assert_text culture_espresso.name
  end

  test "views a User's recommended Locations" do
    culture_espresso = cafes(:culture_espresso)
    thoughtbot_nyc = offices(:thoughtbot_nyc)

    visit location_path(culture_espresso.location)
    click_on culture_espresso.creator.name, match: :first

    assert_text culture_espresso.creator.name
    assert_text culture_espresso.name
    assert_text thoughtbot_nyc.name
  end
end
