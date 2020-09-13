require "test_helper"

class LocationsControllerTest < ActionDispatch::IntegrationTest
  test "#index includes the number of results" do
    get root_path

    assert_text "2 results"
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

  def assert_text(text)
    assert_includes document_root_element.text.squish, text.squish
  end
end
