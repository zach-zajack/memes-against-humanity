require 'test_helper'

class PlayerControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get player_new_url
    assert_response :success
  end

end
