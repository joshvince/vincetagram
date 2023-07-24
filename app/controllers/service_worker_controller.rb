class ServiceWorkerController < ApplicationController
  protect_from_forgery except: %i[service_worker add_subscription]

  def service_worker
  end

  def manifest
  end

  def add_subscription
    blob = params.slice('endpoint', 'expirationTime', 'keys').to_json
    subscription = PushSubscription.new(user: current_user, blob:)

    if subscription.save
      render json: { status: :ok }
    else
      render json: { status: :unprocessable_entity }
    end
  end
end
