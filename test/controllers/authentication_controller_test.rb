require 'test_helper'

class AuthenticationControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @access_token = 'abcdefg123456'

    @fb_user = stub()
    @fb_user.stubs(:authenticate).returns(@fb_user)

    FbGraph2::User.stubs(:new).returns(@fb_user)


    @auth_stub = stub()
    @auth_stub.stubs(:fb_exchange_token=).with(@access_token)
    @auth_stub.stubs(:access_token!).returns('success')

    FbGraph2::Auth.stubs(:new).returns(@auth_stub)
  end

  test "should get session token" do
    @fb_user.stubs(:fetch).returns(@fb_user)

    post '/get_session_token', as: :json,
         params: { auth: { id: @user.id,
                           access_token: @access_token } }
    assert_response :success
    assert_equal 'success', response.parsed_body['user']['access_token']
  end

  test "should raise invalid token exception" do
    @fb_user.stubs(:fetch)
            .raises(FbGraph2::Exception::InvalidToken, 'derp')

    post '/get_session_token', as: :json,
         params: { auth: { id: @user.id,
                           access_token: @access_token } }

    assert_response :unauthorized
  end

  test "should create new user with id and session token" do
    @fb_user.stubs(:fetch).returns(@fb_user)

    post '/get_session_token', as: :json,
         params: { auth: { id: 43,
                           access_token: @access_token } }
    user = User.find_by(profile_id: 43)

    assert_instance_of User, user
    assert_match /^[a-z0-9]{64}$/, user.session_token
  end

  test "should throw bad request if id and access_token are missing" do
    @fb_user.stubs(:fetch).returns(@fb_user)

    post '/get_session_token'

    assert_response :bad_request
  end

  test "should allow big profile integer id values" do
    @fb_user.stubs(:fetch).returns(@fb_user)

    post '/get_session_token', as: :json,
         params: { auth: { id: 10206089230415618,
                           access_token: @access_token } }

    assert_response :success
  end

end
