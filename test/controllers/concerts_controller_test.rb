require 'test_helper'

class ConcertsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @martin = users(:martin)
    @christian = users(:christian)

    @taproot = concerts(:taproot)
    @disturbed = concerts(:disturbed)
  end

  test "should list all concerts and the number of attendees" do
    get concerts_url, as: :json, headers: {
          "Authorization" => "Token token=#{@martin.session_token}"
        }

    assert_equal 2, response.parsed_body[0]['num_attendees']
    assert_equal 1, response.parsed_body[0]['num_friend_attendees']
    assert_equal 3, response.parsed_body[1]['num_attendees']
    assert_equal 2, response.parsed_body[2]['num_attendees']
  end

  test "should find attendees of a certain concert sorted by friend status" do
    get "/concerts/#{@taproot.id}", as: :json, headers: {
          "Authorization" => "Token token=#{@martin.session_token}"
        }

    assert response.parsed_body['attendees'][0]['friend']
    refute response.parsed_body['attendees'][1]['friend']
  end

  test "should be able to attend an event" do
    post "/concerts/#{@taproot.id}", as: :json, headers: {
           "Authorization" => "Token token=#{@martin.session_token}"
         }

    martin = User.find_by(profile_id: @martin.profile_id)

    assert_includes martin.concerts, @taproot

    assert_equal 3, response.parsed_body['num_attendees']
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

    assert response.parsed_body['attendees'][1]['interest']['individual']
  end

  test "should be able to look for a group to join for a concert" do

    post "/concerts/#{@disturbed.id}/look_for_group", as: :json, headers: {
           "Authorization" => "Token token=#{@martin.session_token}"
         }

    interest = @martin.interests.find_by(concert_id: @disturbed.id)

    refute interest.individual
    assert interest.group

    assert response.parsed_body['attendees'][1]['interest']['group']
  end

  test "should allow user to show interest in a friend or stranger" do
    post "/concerts/#{@taproot.id}/show_interest/#{@mads.profile_id}", as: :json, headers: {
           "Authorization" => "Token token=#{@martin.session_token}"
         }

    friend = User.find(@mads)
    friend.likes
  end
end
