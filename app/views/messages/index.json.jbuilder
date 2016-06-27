json.array!(@messages) do |message|
  json.extract! message, :date, :text
  json.uniqueId message.id
  json.position message.position
  json.name message.author.name.split(' ').first
  json.extract! message.author, :profile_id, :picture
end
