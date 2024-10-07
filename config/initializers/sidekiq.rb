# Sidekiq.configure_server do |config|
#   config.redis = { url: ENV['REDIS_URL'] || 'redis://localhost:6379/0' }
# end

# Sidekiq.configure_client do |config|
#   config.redis = { url: ENV['REDIS_URL'] || 'redis://localhost:6379/0' }
# end


Sidekiq.configure_server do |config|
  redis_url = ENV['REDIS_URL'] || 'redis://localhost:6379/0'

  config.redis = if Rails.env.production?
                   { url: redis_url, ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE } }
                 else
                   { url: redis_url }
                 end
end

Sidekiq.configure_client do |config|
  redis_url = ENV['REDIS_URL'] || 'redis://localhost:6379/0'

  config.redis = if Rails.env.production?
                   { url: redis_url, ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE } }
                 else
                   { url: redis_url }
                 end
end
