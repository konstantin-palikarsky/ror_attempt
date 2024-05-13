require "test_helper"

class ThesesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get theses_index_url
    assert_response :success
  end

  test "should get show" do
    get theses_show_url
    assert_response :success
  end
end
