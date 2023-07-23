class InvitesController < ApplicationController
  # This controller should probably really be called Users but passwordless doesn't like intervening
  before_action :require_admin_user!

  def index
    @users = User.preload(:passwordless_sessions).all.sort_by(&:name)
  end

  private

  def require_admin_user!
    return if current_user&.admin?
    save_passwordless_redirect_location!(User)
    redirect_to feed_path
  end
end
