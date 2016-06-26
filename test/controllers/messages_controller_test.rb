require 'test_helper'

class MessagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @above_beyond_chat = chats(:above_beyond_chat)
    @abmsg1_martin = messages(:above_beyond_msg_1_martin)
    @martin = users(:martin)
  end

  test "should get all messages in a specified chat" do
    get chat_messages_url(@above_beyond_chat), as: :json, headers: {
          "Authorization" => "Token token=#{@martin.session_token}"
        }

    json = response.parsed_body

    msg1 = json.first
    msg2 = json.second

    assert_operator msg1['date'], :>, msg2['date']
  end

  test "should create message" do
    assert_difference('Message.count') do
      post chat_messages_url(@above_beyond_chat), as: :json,
           headers: {
             "Authorization" => "Token token=#{@martin.session_token}"
           }, params: { message: {
                          profile_id: @martin.id,
                          content: 'derpalicious' } }
    end

    assert_response 201
  end

  # test "should show message" do
  #   get message_url(@message)
  #   assert_response :success
  # end

  # test "should update message" do
  #   patch message_url(@message), params: { message: { author: @message.author, chat: @message.chat, content: @message.content, date: @message.date } }
  #   assert_response 200
  # end

  # test "should destroy message" do
  #   assert_difference('Message.count', -1) do
  #     delete message_url(@message)
  #   end

  #   assert_response 204
  # end
end
