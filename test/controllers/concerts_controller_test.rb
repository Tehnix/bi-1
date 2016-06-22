require 'test_helper'

class ConcertsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @martin = users(:martin)
    @christian = users(:christian)

    @taproot = concerts(:taproot)
  end

  test "should list all concerts with attending friends through friendships" do
    get concerts_url, as: :json, headers: {
          "Authorization" => "Token token=#{@martin.session_token}"
        }

    assert_equal @christian.profile_id, response.parsed_body[0]['friend_attendees'][0]['profile_id']
  end


  test "should find friends attending a certain concert" do
    get concert_url(@taproot), as: :json, headers: {
          "Authorization" => "Token token=#{@martin.session_token}"
        }

    assert_equal @christian.profile_id, response.parsed_body['friend_attendees'][0]['profile_id']
  end
end
