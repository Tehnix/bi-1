require 'test_helper'

# https://github.com/rails/rails/issues/25183

class ChatsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @chat = chats(:one)
    @user = users(:one)
  end

  test "should get index" do

    get chats_url, as: :json, headers: {
          "Authorization" => "Token token=#{@user.session_token}"
        }

    assert_response :success
  end

  test "should show chat" do
    get chat_url(@chat), as: :json, headers: {
          "Authorization" => "Token token=#{@user.session_token}"
        }

    assert_response :success
  end

end
