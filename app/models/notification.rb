class Notification
  include ActionView::Helpers::AssetUrlHelper

  def self.publish_for_post(post)
    new(post).publish_to_all
  end

  def initialize(post)
    @post = post
  end

  def publish_to_all
    PushSubscription.where.not(user: post.user).each { |subscription| publish_to_subscription(subscription) }
  end

  private

  attr_reader :post

  def publish_to_subscription(subscription)
    WebPush.payload_send(
      message: message.to_json,
      endpoint: subscription.endpoint,
      p256dh: subscription.keys['p256dh'],
      auth: subscription.keys['auth'],
      vapid: {
        subject: "mailto:josh@foo.com",
        public_key: ENV['VAPID_PUBLIC_KEY'],
        private_key: ENV['VAPID_PRIVATE_KEY']
      },
      ssl_timeout: 5,
      open_timeout: 5,
      read_timeout: 5
    )
  rescue WebPush::ExpiredSubscription, WebPush::InvalidSubscription => e
    subscription.destroy!
  end

  def message
    {
      title: "#{post.user.name} posted a new photo",
      options: {
        badge: asset_path('icons/icon-64.png'),
        icon: asset_path('icons/icon-128.png'),
        body: post.caption.truncate(30, separator: ' '),
        tag: 'postcard-notification'
      } #TODO: expand this according to https://developer.mozilla.org/en-US/docs/Web/API/ServiceWorkerRegistration/showNotification
    }
  end
end
