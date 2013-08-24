DAILYMILE_CONFIG = YAML.load_file("#{Rails.root}/config/dailymile.yml").with_indifferent_access[Rails.env]
REDIS_CONFIG = YAML.load_file("#{Rails.root}/config/redis.yml").with_indifferent_access[Rails.env]
SIDEKIQ_CONFIG = YAML.load_file("#{Rails.root}/config/sidekiq.yml").with_indifferent_access[Rails.env]
