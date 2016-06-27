json.extract! @chat, :id, :concert_id, :unread_count, :created_at, :updated_at

json.messages @chat.messages do |message|
  json.extract! message, :author_id, :text, :date, :position
  json.uniqueId message.id
  json.author_name message.author.name.split(' ').first
end
