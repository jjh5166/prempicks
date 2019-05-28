if Rails.env.production?
  Sidekiq.configure_server do |config|
    config.redis = ENV['REDIS_URL']
  end

  Sidekiq.configure_client do |config|
    config.redis = ENV['REDIS_URL']
  end
end
