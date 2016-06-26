json.extract! @chat, :id, :concert_id, :unread_count, :created_at, :updated_at

json.messages @chat.messages do |message|
  json.extract! message, :id, :author_id, :content, :date
  json.author_name message.author.name
end
