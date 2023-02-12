if Rails.env.production?
  Sentry.init do |config|
    config.dsn = 'https://9dc33303548441a3898e66d9652fac88@o1287685.ingest.sentry.io/4504231010697216'
    config.breadcrumbs_logger = [:active_support_logger, :http_logger]

    # Set traces_sample_rate to 1.0 to capture 100%
    # of transactions for performance monitoring.
    # We recommend adjusting this value in production.
    config.traces_sample_rate = 0.001
    # or
    config.traces_sampler = lambda do |context|
      true
    end
  end
end
