require 'test_helper'

class AuthenticationControllerTest < ActionDispatch::IntegrationTest
  setup do
    @martin = users(:martin)
    @access_token = 'abcdefg123456'

    @fb_user = stub()
    @fb_picture = stub()

    @fb_user.stubs(:authenticate).returns(@fb_user)
    @fb_user.stubs(:picture).returns(@fb_picture)
    @fb_picture.stubs(:url).returns('profile_picture_url')


    user = stub()
    user.stubs(:picture).returns(@fb_picture)
    user.stubs(:id).returns(1)
                   .then
                   .returns(2)
                   .then
                   .returns(3)
                   .then
                   .returns(4)
                   .then
                   .returns(5)
                   .then
                   .returns(6)

    user_array = stub()
    user_array.stubs(:each).multiple_yields(user, user, user)
    user_array.stubs(:next).returns(user_array)
                           .then
                           .returns([])
    user_array.stubs(:empty?).returns(false).then.returns(true)

    @fb_user.stubs(:friends).returns(user_array)

    FbGraph2::User.stubs(:new).returns(@fb_user)

    @auth_stub = stub()
    @auth_stub.stubs(:fb_exchange_token=).with(@access_token)
    @auth_stub.stubs(:access_token!).returns('success')

    FbGraph2::Auth.stubs(:new).returns(@auth_stub)
  end

  test "should get session token" do
    @fb_user.stubs(:fetch).returns(@fb_user)

    post '/auth', as: :json,
         params: { auth: { id: @martin.id,
                           access_token: @access_token } }
    assert_response :success
    assert_equal 'success', response.parsed_body['user']['access_token']
  end

  test "should raise invalid token exception" do
    @fb_user.stubs(:fetch)
            .raises(FbGraph2::Exception::InvalidToken, 'derp')

    post '/auth', as: :json,
         params: { auth: { id: @martin.id,
                           access_token: @access_token } }

    assert_response :unauthorized
  end

  test "should create new user with id and session token" do
    @fb_user.stubs(:fetch).returns(@fb_user)

    post '/auth', as: :json,
         params: { auth: { id: 43,
                           access_token: @access_token } }
    user = User.find_by(profile_id: 43)

    assert_instance_of User, user
    assert_match /^[a-z0-9]{64}$/, user.session_token
  end

  test "should throw bad request if id and access_token are missing" do
    @fb_user.stubs(:fetch).returns(@fb_user)

    post '/auth'

    assert_response :bad_request
  end

  test "should allow big profile integer id values" do
    @fb_user.stubs(:fetch).returns(@fb_user)

    post '/auth', as: :json,
         params: { auth: { id: 10206089230415618,
                           access_token: @access_token } }

    assert_response :success
  end

  test "should store profile picture url from Facebook" do
    @fb_user.stubs(:fetch).returns(@fb_user)

    post '/auth', as: :json,
         params: { auth: { id: 43,
                           access_token: @access_token } }

    user = User.find_by(profile_id: 43)

    assert_equal 'profile_picture_url', user.picture
  end

  test "should store friend associations during registration" do
    @fb_user.stubs(:fetch).returns(@fb_user)

    post '/auth', as: :json,
         params: { auth: { id: 43,
                           access_token: @access_token } }

    stored_user = User.find_by(profile_id: 43)

    assert_equal 6, stored_user.friends.length
  end
end
