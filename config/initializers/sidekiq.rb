if Rails.env.production?
  Sidekiq.configure_server do |config|
    config.redis = REDIS_URL
  end

  Sidekiq.configure_client do |config|
    config.redis = REDIS_URL
  end
end
