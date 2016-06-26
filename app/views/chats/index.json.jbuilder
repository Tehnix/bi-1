json.array!(@chats) do |chat|
  json.extract! chat, :id, :concert_id
  json.participants chat.excluded_participants do |participant|
    json.extract! participant, :id, :name, :picture
  end

  unless chat.recent_message.nil?
    json.recent_message do
      json.author chat.recent_message.author.name
      json.extract! chat.recent_message, :date, :text
      json.uniqueId chat.recent_message.id
    end
  end
end
