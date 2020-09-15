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

  test "renders Locations attached to a Recommendation's Rich Text" do
    culture_espresso = cafes(:culture_espresso)
    thoughtbot_nyc = offices(:thoughtbot_nyc)

    visit location_path(culture_espresso.location)
    within_recommendations { click_on thoughtbot_nyc.name }

    within_sidebar do
      assert_no_link thoughtbot_nyc.name
      assert_text thoughtbot_nyc.name
      assert_text thoughtbot_nyc.line1
    end
    within_map do
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

  test "search within the map area for Locations" do
    thoughtbot_nyc = offices(:thoughtbot_nyc)
    culture_espresso = cafes(:culture_espresso)
    cho_dang_gol = restaurants(:cho_dang_gol_korean_restaurant)

    visit location_path(thoughtbot_nyc.location)
    zoom_out_map steps: 2
    click_on "Search this area"

    within_sidebar do
      assert_link cho_dang_gol.name
      assert_link thoughtbot_nyc.name
      assert_link culture_espresso.name
    end
    within_map do
      assert_link cho_dang_gol.name
      assert_link thoughtbot_nyc.name
      assert_link culture_espresso.name
    end
  end

  test "Search this area button is hidden if the Map is unmoved" do
    visit root_path
    refresh

    assert_no_button "Search this area"
  end

  def within_recommendations(&block)
    within "dl", &block
  end

  def within_sidebar(&block)
    wait_for_animation
    within "main > section:first-of-type", &block
  end

  def within_map(&block)
    wait_for_animation
    within ".leaflet-container", &block
  end

  def zoom_out_map(steps: 1)
    steps.times { within_map { click_on "Zoom out" } }
    wait_for_animation
  end

  def wait_for_animation
    assert_no_selector ".leaflet-zoom-anim"
  end
end
