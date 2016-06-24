json.array!(@concerts) do |concert|
  json.extract! concert, :id, :artist, :start_time, :end_time, :venue,
                :num_attendees, :num_friend_attendees
end
