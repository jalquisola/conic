Sidekiq.configure_server do |config|
  config.redis = {
    :url => "redis://#{REDIS_CONFIG[:host]}:#{REDIS_CONFIG[:port]}",
    :namespace => "sidekiq"
  }
end

Sidekiq.configure_client do |config|
  config.redis = {
    :url => "redis://#{REDIS_CONFIG[:host]}:#{REDIS_CONFIG[:port]}",
    :namespace => "sidekiq"
  }
end

