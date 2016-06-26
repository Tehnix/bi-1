json.array!(@messages) do |message|
  json.extract! message, :id, :date, :content
  json.author message.author, :profile_id, :name, :picture
end
