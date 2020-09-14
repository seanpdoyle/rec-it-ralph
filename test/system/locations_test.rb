require "application_system_test_case"

class LocationsTest < ApplicationSystemTestCase
  test "view Cafes near thoughtbot NYC" do
    thoughtbot_nyc = offices(:thoughtbot_nyc)
    culture_espresso = cafes(:culture_espresso)

    visit root_path

    within_sidebar do
      assert_link thoughtbot_nyc.name
      assert_link culture_espresso.name
    end
    within_map do
      assert_link thoughtbot_nyc.name
      assert_link culture_espresso.name
    end
  end

  test "views a Location" do
    culture_espresso = cafes(:culture_espresso)

    visit root_path
    click_on culture_espresso.name

    within_sidebar do
      assert_text culture_espresso.name
    end
    within_map do
      assert_link culture_espresso.name
    end
  end

  test "views a User's recommended Locations" do
    culture_espresso = cafes(:culture_espresso)
    thoughtbot_nyc = offices(:thoughtbot_nyc)

    visit location_path(culture_espresso.location)
    click_on culture_espresso.creator.name, match: :first

    within_sidebar do
      assert_text culture_espresso.creator.name
      assert_link culture_espresso.name
      assert_link thoughtbot_nyc.name
    end
    within_map do
      assert_link culture_espresso.name
      assert_link thoughtbot_nyc.name
    end
  end

  test "visits a Location by clicking its map marker" do
    culture_espresso = cafes(:culture_espresso)

    visit root_path
    within_map { click_on culture_espresso.name }

    within_sidebar do
      assert_text culture_espresso.name
      assert_no_link culture_espresso.name
    end
  end

  def within_sidebar(&block)
    within "main > section:first-of-type", &block
  end

  def within_map(&block)
    within ".leaflet-container", &block
  end

  test "renders Locations attached to a Recommendation's Rich Text" do
    culture_espresso = cafes(:culture_espresso)
    thoughtbot_nyc = offices(:thoughtbot_nyc)

    visit location_path(culture_espresso.location)
    within_recommendations { click_on thoughtbot_nyc.name }

    assert_text thoughtbot_nyc.name
    assert_text thoughtbot_nyc.line1
  end

  def within_recommendations(&block)
    within "dl", &block
  end
end
