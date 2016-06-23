class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  before_action :require_token

  private

  def require_token
    authenticate_or_request_with_http_token do |token|
      @current_user = User.find_by(session_token: token)
      @current_user unless @current_user.nil?
    end
  end

  def request_http_token_authentication(realm = "Application", message = nil)
    self.headers["WWW-Authenticate"] = %(Token realm="#{realm.gsub(/"/, "")}")
    self.__send__ :render, json: {
      error: 'HTTP Token: Unauthorized.' }, status: :unauthorized
  end
end
