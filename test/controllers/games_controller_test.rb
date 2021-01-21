require 'test_helper'

class GamesControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get game_show_url
    assert_response :success
  end

end
