# frozen_string_literal: true

Passwordless.configure do |config|
  config.default_from_address = 'noreply@mail.vincefamily.net'
  config.restrict_token_reuse = true
  config.expires_at = -> { 1.year.from_now }
  # Matches passwordless 0.x, so invite emails don't expire after 10 minutes.
  config.timeout_at = -> { 1.hour.from_now }
  # The site is invite only: don't reveal whether an email address belongs to someone.
  config.paranoid = true

  config.success_redirect_path = '/feed'
  config.failure_redirect_path = '/sign_in'
  config.sign_out_redirect_path = '/sign_in'
end
