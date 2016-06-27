json.array!(@messages) do |message|
  json.extract! message, :date, :text
  json.uniqueId message.id
  json.position message.position
  json.name message.author.name.split(' ').first
  json.picture message.author.picture
  json.profile_id message.author.profile_id.to_s
end
