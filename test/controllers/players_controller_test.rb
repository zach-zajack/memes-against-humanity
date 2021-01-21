require 'test_helper'

class PlayersControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get player_new_url
    assert_response :success
  end

end
