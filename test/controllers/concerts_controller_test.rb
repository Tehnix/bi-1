require 'test_helper'

class ConcertsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @martin = users(:martin)
    @christian = users(:christian)
    @mads = users(:mads)

    @taproot = concerts(:taproot)
    @disturbed = concerts(:disturbed)
  end

  test "should list all concerts ordered by start time with images and the "\
       "number of attendees" do
    get concerts_url, as: :json, headers: {
          "Authorization" => "Token token=#{@martin.session_token}"
        }

    # Expected number of attendees
    response.parsed_body.each do |concert|
      assert_equal 3, concert['num_attendees'] if
        concert['artist'] == 'Disturbed'

      assert_equal 1, concert['num_friend_attendees'] if
        concert['artist'] == 'Above & Beyond'

      assert_equal 2, concert['num_attendees'] if
        concert['artist'] == 'Taproot'
    end

    # Image url exists
    assert_equal 'placeholder',
                 response.parsed_body[0]['images'][0]['url']
    assert_equal 'placeholder',
                 response.parsed_body[0]['images'][1]['url']

    # Sorted
    assert_operator response.parsed_body[0]['start_time'],
                    :<, response.parsed_body[1]['start_time']
  end

  test "should find attendees of a certain concert sorted by friend status" do
    get "/concerts/#{@taproot.id}", as: :json, headers: {
          "Authorization" => "Token token=#{@martin.session_token}"
        }

    assert response.parsed_body['attendees'][0]['friend']
    refute response.parsed_body['attendees'][1]['friend']
  end

  test "should be able to attend and unattend an event" do
    post "/concerts/#{@taproot.id}", as: :json, headers: {
           "Authorization" => "Token token=#{@martin.session_token}"
         }

    martin = User.find_by(profile_id: @martin.profile_id)

    assert_includes martin.concerts, @taproot

    assert_equal 3, response.parsed_body['num_attendees']

    delete "/concerts/#{@taproot.id}", as: :json, headers: {
             "Authorization" => "Token token=#{@martin.session_token}"
           }

    assert_equal 2, response.parsed_body['num_attendees']
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

    assert response.parsed_body['me']['interest']['individual']

    delete "/concerts/#{@disturbed.id}/look_for_individual", as: :json, headers: {
           "Authorization" => "Token token=#{@martin.session_token}"
         }

    refute response.parsed_body['me']['interest']['individual']
  end

  test "should be able to look for a group to join for a concert" do

    post "/concerts/#{@disturbed.id}/look_for_group", as: :json, headers: {
           "Authorization" => "Token token=#{@martin.session_token}"
         }

    interest = @martin.interests.find_by(concert_id: @disturbed.id)

    refute interest.individual
    assert interest.group

    assert response.parsed_body['me']['interest']['group']

    delete "/concerts/#{@disturbed.id}/look_for_group", as: :json, headers: {
           "Authorization" => "Token token=#{@martin.session_token}"
         }

    refute response.parsed_body['me']['interest']['group']
  end

  test "should throw bad request if user has not shown interest in specified concert" do
    post "/concerts/#{@taproot.id}/like/#{@mads.profile_id}", as: :json, headers: {
           "Authorization" => "Token token=#{@martin.session_token}"
         }

    assert_response :bad_request
  end

  test "should allow a user to like and unlike an interest of another user" do
    post "/concerts/#{@disturbed.id}/like/#{@christian.profile_id}", as: :json, headers: {
           "Authorization" => "Token token=#{@martin.session_token}"
         }

    friend = User.find(@christian.id)
    assert_equal 1, friend.likes.length

    delete "/concerts/#{@disturbed.id}/like/#{@christian.profile_id}", as: :json, headers: {
             "Authorization" => "Token token=#{@martin.session_token}"
           }

    friend = User.find(@christian.id)
    assert_equal 0, friend.likes.length
  end
end
