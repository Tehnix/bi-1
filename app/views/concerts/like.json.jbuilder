json.attendee do
  json.profile_id @user.profile_id.to_s
  json.likes_you @likes_you
  json.you_like @you_like
  json.mutual_concerts @mutual_concerts
  json.interest do
    json.extract! @liked_interest, :individual, :group
  end
end
