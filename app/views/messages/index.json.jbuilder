json.array!(@messages) do |message|
  json.extract! message, :date, :text
  json.uniqueId message.id
  json.position message.position
  json.extract! message.author, :profile_id, :name, :picture
end
