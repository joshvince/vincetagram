class PushSubscription < ApplicationRecord
  belongs_to :user

  def endpoint
    JSON.parse(blob).dig('endpoint')
  end

  # Might be a datetime string or nil
  def expiration_time
    JSON.parse(blob).dig('expirationTime')
  end

  # Should look like this {"p256dh": "something", "auth": "something"}
  def keys
    JSON.parse(blob).dig('keys')
  end
end
