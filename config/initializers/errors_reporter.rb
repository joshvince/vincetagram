require Rails.root.join("lib/errors_reporter").to_s

token = Rails.application.credentials.dig(:errors_reporter, :token)

if Rails.env.production? && token.present?
  Rails.application.config.middleware.use ErrorsReporter::Middleware,
    endpoint: "https://errors.joshvince.site/notify",
    token: token,
    app: "vincetagram"
end
