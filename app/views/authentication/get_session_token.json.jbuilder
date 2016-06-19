json.user do |json|
  json.extract! @user, :profile_id, :session_token
  json.access_token @access_token
end
