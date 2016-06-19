json.user do |json|
  json.extract! @user, :id, :session_token
  json.access_token @access_token
end
