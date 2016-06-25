json.attendee do
  json.extract! @user, :profile_id
  json.likes_you @likes_you
  json.mutual_concerts @mutual_concerts
  json.interest do
    json.extract! @liked_interest, :individual, :group
  end
end
