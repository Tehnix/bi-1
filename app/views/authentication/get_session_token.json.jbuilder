json.user do |json|
  json.extract! @user, :session_token
  json.profile_id @user.profile_id.to_s
  json.access_token @access_token
end
