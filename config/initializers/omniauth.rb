Rails.application.config.middleware.use OmniAuth::Builder do
  provider :dailymile, DAILYMILE_CONFIG['CLIENT_ID'], DAILYMILE_CONFIG['CLIENT_SECRET']
  provider :identity
end
