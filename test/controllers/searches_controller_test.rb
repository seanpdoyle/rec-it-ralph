require "test_helper"

class SearchesControllerTest < ActionDispatch::IntegrationTest
  test "#create redirects to the results" do
    bbox_string = [1, 2, 3, 4].join(", ")

    post searches_path, params: {bounds: bbox_string}

    assert_redirected_to root_url(bounds: bbox_string)
  end
end
