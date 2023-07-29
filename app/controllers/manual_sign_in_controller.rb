class ManualSignInController < ApplicationController
  def sign_in_with_token
    redirect_to auth.token_sign_in_path(params[:token])
  end
end
