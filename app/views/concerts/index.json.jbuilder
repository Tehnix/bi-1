json.array!(@concerts) do |concert|
  json.extract! concert, :id, :artist, :start_time, :end_time, :venue,
                :num_attendees, :friend_attendees
end
