# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :require_admin_user!

  def index
    @users = User.preload(:passwordless_sessions).all.sort_by(&:name)
  end

  def new
    @user = User.new(admin: false)
  end

  def edit
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      send_magic_link(@user)
      redirect_to users_url, notice: 'The user was successfully invited, they should check their inbox'
    else
      render :new, status: :unprocessable_entity, error: 'There was an error, please try again'
    end
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params.merge(admin: false))
      redirect_to users_url, notice: 'The user was successfully updated'
    else
      render :edit, status: :unprocessable_entity, error: 'There was an error, please try again'
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    redirect_to users_url, notice: 'User was successfully deleted.'
  end

  private

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:name, :email, :admin)
  end

  def send_magic_link(user)
    pwless_session = create_passwordless_session!(user)
    Passwordless::Mailer.sign_in(pwless_session).deliver_now
  end
end
