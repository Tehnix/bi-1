class AuthenticationController < ApplicationController

  skip_before_action :require_token

  def get_session_token
    begin
      permitted_params = auth_params
    rescue ActionController::ParameterMissing => e
      render json: { error: e.message }, status: :bad_request
      return
    end

    profile_id = permitted_params[:id]
    @access_token = permitted_params[:access_token]

    fb_user = FbGraph2::User.new(profile_id).authenticate(@access_token)
    begin
      # The user is valid if the fetch command is successful
      fb_user.fetch

      # Extend the short-term token to a long-term one
      auth = FbGraph2::Auth.new(ENV['FACEBOOK_APP_ID'],
                                ENV['FACEBOOK_APP_SECRET'])
      auth.fb_exchange_token = @access_token
      @access_token = auth.access_token!.to_s

      @user = User.find_or_create_by(profile_id: profile_id)

      session_token = Digest::SHA256.hexdigest(@access_token)

      if @user.session_token != session_token
        @user.update(session_token: session_token)
      end

      render :get_session_token, status: :ok, location: '/get_session_token'

    rescue FbGraph2::Exception::InvalidToken => e
      render json: { error: e.message }, status: :unauthorized
    rescue FbGraph2::Exception::BadRequest => e
      render json: { error: e.message }, status: :bad_request
    end
  end

  private

  def auth_params
    params.require(:auth).permit(:id, :access_token)
  end

end
