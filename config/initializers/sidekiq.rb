Sidekiq.configure_server do |config|
  config.redis = {
    :url => "redis://#{REDIS_CONFIG[:host]}:#{REDIS_CONFIG[:port]}",
    :namespace => SIDEKIQ_CONFIG[:namespace] || "sidekiq"
  }
end

Sidekiq.configure_client do |config|
  config.redis = {
    :url => "redis://#{REDIS_CONFIG[:host]}:#{REDIS_CONFIG[:port]}",
    :namespace => SIDEKIQ_CONFIG[:namespace] || "sidekiq"
  }
end

# Reconfigure sidekiq options for action mailer extension
#class Sidekiq::Extensions::DelayedMailer
#  sidekiq_options :retry => 3
#end
