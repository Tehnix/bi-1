json.extract! @concert, :id, :artist, :start_time, :end_time, :venue,
              :created_at, :updated_at, :num_attendees, :num_friend_attendees
json.attendees(@interests) do |interest|
  json.extract! interest.user, :profile_id, :picture, :friend
  json.interest do
    json.extract! interest, :individual, :group
  end
end
