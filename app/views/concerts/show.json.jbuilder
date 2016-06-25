json.extract! @concert, :id, :artist, :start_time, :end_time, :venue,
              :created_at, :updated_at, :num_attendees, :num_friend_attendees

json.images @concert.images do |image|
  json.extract! image, :image_type, :url, :width, :height
end

json.attendees(@interests) do |interest|
  json.extract! interest.user, :profile_id, :picture, :friend, :likes_you,
                :mutual_concerts
  json.interest do
    json.extract! interest, :individual, :group
  end
end

unless @interest.nil?
  json.me do
    json.extract! @current_user, :likes_you
    json.interest do
      json.extract! @interest, :individual, :group
    end
  end
end
