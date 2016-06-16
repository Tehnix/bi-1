json.array!(@concerts) do |concert|
  json.extract! concert, :id, :artist, :time_of_day, :venue
  json.url concert_url(concert, format: :json)
end
