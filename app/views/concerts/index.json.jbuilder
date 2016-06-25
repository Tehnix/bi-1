json.array!(@concerts) do |concert|
  json.extract! concert, :id, :artist, :start_time, :end_time, :venue,
                :num_attendees, :num_friend_attendees
  json.images concert.images do |image|
    json.extract! image, :image_type, :url, :width, :height
  end
end
