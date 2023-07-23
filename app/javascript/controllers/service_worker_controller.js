import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  connect() {
    if (navigator.serviceWorker) {
      navigator.serviceWorker
        .register('/service-worker.js', { scope: '/' })
        .then(() => navigator.serviceWorker.ready)
        .then((registration) => {
          if ('SyncManager' in window) {
            registration.sync.register('sync-forms');
          } else {
            window.alert('This browser does not support background sync.');
          }
        })
        .then(() =>
          console.log('[ServiceWorkerController]', 'Service worker registered!')
        );
    }
  }
}
