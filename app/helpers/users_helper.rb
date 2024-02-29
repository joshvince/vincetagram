# frozen_string_literal: true

module UsersHelper
  def unclaimed_token(user)
    return nil unless user.latest_unclaimed_session

    send(Passwordless.mounted_as).token_sign_in_url(user.latest_unclaimed_session.token)
  end
end
