require 'test_helper'

# https://github.com/rails/rails/issues/25183

class ChatsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @disturbed_chat = chats(:disturbed_chat)
    @martin = users(:martin)
    @christian = users(:christian)
    @mads = users(:mads)
    @benjamin = users(:benjamin)
  end

  test "should get chats belonging to current user sorted by recent activity" do
    get chats_url, as: :json, headers: {
          "Authorization" => "Token token=#{@martin.session_token}"
        }

    json = response.parsed_body

    assert_equal 3, json.length
    assert_equal @disturbed_chat.id, json[0]['id']
    assert_equal @mads.name, json[0]['recent_message']['author']
    assert_equal @benjamin.name, json[1]['recent_message']['author']
  end

  test "should show chat information (and settings?)" do
    get chat_url(@disturbed_chat), as: :json, headers: {
          "Authorization" => "Token token=#{@martin.session_token}"
        }

    assert_response :success
  end

end
