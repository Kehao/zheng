REDIS_CONFIG = YAML.load_file(File.join(Rails.root, "config/redis.yml"))[Rails.env]

Sidekiq.configure_server do |config|
  config.redis = { :url => "redis://#{REDIS_CONFIG['host']}:#{REDIS_CONFIG['port']}/0", :namespace => 'skyeye:sidekiq' }
end

Sidekiq.configure_client do |config|
  config.redis = { :url => "redis://#{REDIS_CONFIG['host']}:#{REDIS_CONFIG['port']}/0", :namespace => 'skyeye:sidekiq', :size => 1 }
end
