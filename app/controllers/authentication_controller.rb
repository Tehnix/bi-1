class AuthenticationController < ApplicationController

  skip_before_action :require_token

  def get_session_token
    profile_id = params[:id]
    access_token = params[:access_token]

    fb_user = FbGraph2::User.new(profile_id).authenticate(access_token).fetch
    begin
      fb_user.fetch

      @user = User.create_with(name: fb_user.first_name)
                  .find_or_create_by(id: profile_id)

      session_token = Digest::SHA256.hexdigest(access_token)

      if @user.session_token != session_token
        @user.update(session_token: session_token)
      end

      render :get_session_token, status: :ok, location: '/get_session_token'
    rescue FbGraph2::Exception::InvalidToken => e
      render json: { error: e.message }, status: :unauthorized
    end
  end

end
