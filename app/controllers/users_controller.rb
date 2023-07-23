class UsersController < ApplicationController
  # This controller should probably really be called Users but passwordless doesn't like intervening
  before_action :require_admin_user!

  def index
    @users = User.preload(:passwordless_sessions).all.sort_by(&:name)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update(user_params.merge(admin: false))
        format.html { redirect_to users_url, notice: "The user was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity, error: "There was an error, please try again" }
      end
    end
  end

  private

  def require_admin_user!
    return if current_user&.admin?
    save_passwordless_redirect_location!(User)
    redirect_to feed_path
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:name, :email, :admin)
  end
end
