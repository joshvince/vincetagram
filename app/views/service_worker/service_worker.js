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

self.addEventListener('install', onInstall);
self.addEventListener('activate', onActivate);
self.addEventListener('fetch', onFetch);
self.addEventListener('push', onPush);
