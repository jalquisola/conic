json.array!(@short_messages) do |short_message|
  json.extract! short_message, 
  json.url short_message_url(short_message, format: :json)
end
