require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "#show includes relevant information" do
    ralph = users(:ralph)

    get user_path(ralph)

    assert_select "title", text: ralph.name
    assert_text ralph.name
    assert_text ralph.biography
    assert_text ralph.neighborhood
  end
end
