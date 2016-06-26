require 'test_helper'

# https://github.com/rails/rails/issues/25183

class ChatsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @disturbed_chat = chats(:disturbed_chat)
    @disturbed = concerts(:disturbed)
    @taproot = concerts(:disturbed)
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

    json[0]['participants'].each do |participant|
      refute participant['picture'] == 'martin_picture'
    end

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

  test "should be able to create a new chat for two people that like one "\
       "another" do
    post chats_url, as: :json,
         params: { concert_id: @disturbed.id, profile_id: @mads.profile_id }, headers: {
           "Authorization" => "Token token=#{@martin.session_token}"
         }

    json = response.parsed_body
    refute json['id'].nil?
  end

  test "should not be able to create a new chat for two people that haven't "\
       "liked one another" do
    post chats_url, as: :json, params: { concert_id: @taproot.id, profile_id: @christian.profile_id }, headers: {
           "Authorization" => "Token token=#{@martin.session_token}"
         }

    assert_response :bad_request
  end

  test "should not be able to create a new chat for two people that don't "\
       "share an interest" do
    post chats_url, as: :json, params: { concert_id: @taproot.id, profile_id: @christian.profile_id }, headers: {
           "Authorization" => "Token token=#{@martin.session_token}"
         }

    assert_response :bad_request
  end

  test "should not continue to append participants to chat" do
    assert_difference('Chat.count', 1) do
      post chats_url, as: :json,
         params: { concert_id: @disturbed.id, profile_id: @mads.profile_id }, headers: {
           "Authorization" => "Token token=#{@martin.session_token}"
         }

    post chats_url, as: :json,
         params: { concert_id: @disturbed.id, profile_id: @mads.profile_id }, headers: {
           "Authorization" => "Token token=#{@martin.session_token}"
         }

    end
  end
end
