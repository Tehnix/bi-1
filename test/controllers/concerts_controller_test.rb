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
    get "/concerts/#{@taproot.id}", as: :json, headers: {
          "Authorization" => "Token token=#{@martin.session_token}"
        }

    assert_equal @christian.profile_id, response.parsed_body['friend_attendees'][0]['profile_id']
  end

  test "should be able to attend event" do
    post "/concerts/#{@taproot.id}", as: :json, headers: {
           "Authorization" => "Token token=#{@martin.session_token}"
         }

    martin = User.find_by(profile_id: @martin.profile_id)

    assert_equal @taproot.artist, martin.concerts[2].artist
  end

  test "should not be able to set interest if user is not attending" do
    post "/concerts/#{@taproot.id}/look_for_individual", as: :json, headers: {
           "Authorization" => "Token token=#{@martin.session_token}"
         }

    interest = @martin.interests.find_by(concert_id: @taproot.id)
    refute interest
  end

  test "should be able to look for an individual to bring to a concert" do
    post "/concerts/#{@disturbed.id}/look_for_individual", as: :json, headers: {
           "Authorization" => "Token token=#{@martin.session_token}"
         }

    interest = @martin.interests.find_by(concert_id: @disturbed.id)

    assert interest.individual
    refute interest.group

    get "/concerts/#{@disturbed.id}", as: :json, headers: {
          "Authorization" => "Token token=#{@martin.session_token}"
        }

    assert response.parsed_body['attendees'][1]['interest']['individual']
  end

  test "should be able to look for a group to join for a concert" do

    post "/concerts/#{@disturbed.id}/look_for_group", as: :json, headers: {
           "Authorization" => "Token token=#{@martin.session_token}"
         }

    interest = @martin.interests.find_by(concert_id: @disturbed.id)

    refute interest.individual
    assert interest.group

    get "/concerts/#{@disturbed.id}", as: :json, headers: {
          "Authorization" => "Token token=#{@martin.session_token}"
        }

    assert response.parsed_body['attendees'][1]['interest']['group']
  end
    post "/concerts/#{@taproot.id}/look_for_group", as: :json, headers: {
           "Authorization" => "Token token=#{@martin.session_token}"
         }
  end
end
