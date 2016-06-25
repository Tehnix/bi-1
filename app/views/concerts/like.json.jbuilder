json.attendee do
  json.extract! @user, :profile_id
  json.mutual_concerts @mutual_concerts
  json.interest do
    json.extract! @liked_interest, :individual, :group
  end
end
