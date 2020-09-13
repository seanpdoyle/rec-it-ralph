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
end
