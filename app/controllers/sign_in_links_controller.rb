# frozen_string_literal: true

# Lets an admin create a sign-in link to send someone directly, e.g. by message.
class SignInLinksController < ApplicationController
  before_action :require_admin_user!

  def create
    @user = User.find(params[:user_id])
    pwless_session = create_passwordless_session!(@user)
    @sign_in_link = confirm_auth_sign_in_url(pwless_session, pwless_session.token)
  end
end
