json.array!(@messages) do |message|
  json.extract! message, :id, :author, :date, :content, :chat
  json.url message_url(message, format: :json)
end
