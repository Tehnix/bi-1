json.array!(@chats) do |chat|
  json.extract! chat, :id, :concert_id, :unread_count

  unless chat.recent_message.nil?
    json.recent_message do
      json.author chat.recent_message.author.name
      json.extract! chat.recent_message, :date, :content
    end
  end
end
