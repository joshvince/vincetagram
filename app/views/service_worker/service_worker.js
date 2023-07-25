function onInstall(event) {
  console.log('[Serviceworker]', 'Installing!', event);
}

function onActivate(event) {
  console.log('[Serviceworker]', 'Activating!', event);
}

function onFetch(event) {
  console.log('[Serviceworker]', 'Fetching!', event);
}

function onPush(event) {
  let { title, options } = JSON.parse(event.data.text());

  event.waitUntil(self.registration.showNotification(title, options));
}

function onNotificationClick(event) {
  const feedUrl = new URL('/feed', self.location.origin).href;

  event.notification.close();

  const openOrFocusFeed = clients
    .matchAll({
      type: 'window',
      includeUncontrolled: true,
    })
    .then((windowClients) => {
      let matchingClient = null;

      windowClients.every((windowClient) => {
        if (windowClient.url === feedUrl) {
          // There's already a tab/window open with the feed, so stop the iterator.
          matchingClient = windowClient;
          return false;
        }
        // Truthy returns will keep iterating
        return true;
      });

      if (matchingClient) {
        // We found an open tab/window, so focus that
        return matchingClient.focus();
      } else {
        // Open a new window
        return clients.openWindow(feedUrl);
      }
    });

  event.waitUntil(openOrFocusFeed);
}

self.addEventListener('install', onInstall);
self.addEventListener('activate', onActivate);
self.addEventListener('fetch', onFetch);
self.addEventListener('push', onPush);
self.addEventListener('notificationclick', onNotificationClick);
