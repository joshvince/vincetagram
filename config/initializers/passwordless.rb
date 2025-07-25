# frozen_string_literal: true

Passwordless.restrict_token_reuse = true
Passwordless.default_from_address = 'noreply@mail.vincefamily.net'
Passwordless.success_redirect_path = '/feed' # When a user succeeds in logging in.
Passwordless.sign_out_redirect_path = '/sign_in'
Passwordless.expires_at = -> { 1.year.from_now }
