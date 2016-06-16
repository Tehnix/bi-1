class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  before_action :require_token

  private

  def require_token
    authenticate_or_request_with_http_token do |token, options|
      @current_user = User.find_by(session_token: token)

      if @current_user.nil?
        render json: { error: "Not authorized" }, status: :unauthorized
      end

      true
    end
  end
end
