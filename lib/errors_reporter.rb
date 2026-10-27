require "json"
require "net/http"
require "rack"
require "uri"

# Client half of errors.joshvince.site, for the apps that report to it. Kept in
# its own namespace because the sink's own server code is `Errors`, and a
# reporting app may well be this one. Nothing here touches Rails at load time,
# so the shim drops into any Rack app with no gems to add.
module ErrorsReporter
  # The non-Rails fallback for params filtering, used by standalone Rack apps
  # (and the demo app) that have no ActiveSupport to borrow the filter from.
  FILTERED = "[FILTERED]"

  def self.filter_params(value, keywords)
    case value
    when Hash
      value.to_h do |key, nested|
        filtered = keywords.any? { |keyword| key.to_s.downcase.include?(keyword.to_s.downcase) }
        [ key, filtered ? FILTERED : filter_params(nested, keywords) ]
      end
    when Array
      value.map { |nested| filter_params(nested, keywords) }
    else
      value
    end
  end

  # Rack middleware: let the app raise, report the exception, then re-raise it
  # untouched. Reporting is a side channel, so every failure in here is
  # swallowed — the reporter must never turn one app error into two.
  class Middleware
    # A report is worthless if it delays the response or the crash, so this is a
    # ceiling on every leg of the POST, not a target.
    TIMEOUT = 2

    # Rails' own logging filter list (sans email), which covers the credentials
    # an app is likely to have in params.
    DEFAULT_PARAM_FILTER = %i[passw secret token authorization api_key _key crypt salt certificate otp ssn cvv cvc].freeze

    # `app:` is the reporting app's name in the sink, not the Rack app, so the
    # Rack app keeps the positional slot under a name of its own.
    def initialize(rack_app, endpoint:, token:, app:, environment: nil, param_filter: [])
      @rack_app = rack_app
      @endpoint = endpoint
      @token = token
      @app_name = app
      @environment = environment || self.class.default_environment
      @param_filter = DEFAULT_PARAM_FILTER + Array(param_filter)
    end

    # Rails wins when it is loaded, because that is the environment the app is
    # actually running in; RACK_ENV is the plain-Rack case.
    def self.default_environment
      return Rails.env.to_s if defined?(Rails) && Rails.respond_to?(:env)

      ENV["RACK_ENV"] || "development"
    end

    def call(env)
      @rack_app.call(env)
    rescue StandardError => error
      report(error, env)
      raise
    end

    private

    def report(error, env)
      deliver(payload_for(error, env))
    rescue StandardError
      nil
    end

    def payload_for(error, env)
      {
        app: @app_name,
        environment: @environment,
        error_class: error.class.name,
        message: error.message,
        stack: Array(error.backtrace),
        context: context_for(env)
      }
    end

    def context_for(env)
      request = Rack::Request.new(env)
      context = {
        url: request.fullpath,
        method: request.request_method,
        params: filtered_params(request),
        user_agent: request.user_agent,
        host: request.host
      }
      context[:revision] = ENV["GIT_REVISION"] if ENV["GIT_REVISION"]
      context
    rescue StandardError
      { url: env["PATH_INFO"], method: env["REQUEST_METHOD"] }
    end

    # A request the Rack parser chokes on is exactly the request most likely to
    # have raised, so its params degrade to nothing rather than to an error.
    def filtered_params(request)
      params = request.params
      if defined?(ActionDispatch::Http::ParameterFilter)
        ActionDispatch::Http::ParameterFilter.new(@param_filter).filter(params)
      elsif defined?(ActiveSupport::ParameterFilter)
        ActiveSupport::ParameterFilter.new(@param_filter).filter(params)
      else
        ErrorsReporter.filter_params(params, @param_filter)
      end
    rescue StandardError
      {}
    end

    def deliver(payload)
      uri = URI(@endpoint)
      post = Net::HTTP::Post.new(uri)
      post["Content-Type"] = "application/json"
      post["Authorization"] = "Bearer #{@token}"
      post.body = JSON.generate(payload)

      Net::HTTP.start(
        uri.host, uri.port,
        use_ssl: uri.scheme == "https",
        open_timeout: TIMEOUT, read_timeout: TIMEOUT, write_timeout: TIMEOUT
      ) { |http| http.request(post) }
    end
  end
end
