json.array!(@chats) do |chat|
  json.extract! chat, :id, :type, :user_id, :concert_id, :unread_count
  json.url chat_url(chat, format: :json)
end
