require "test_helper"

class UserResultsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get user_results_index_url
    assert_response :success
  end

  test "should get show" do
    get user_results_show_url
    assert_response :success
  end
end
