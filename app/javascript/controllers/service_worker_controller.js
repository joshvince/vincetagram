import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = [ 'notificationRequester', 'enableNotificationButton' ];

  connect() {
    this.registerServiceWorker()
    this.handleDisplayOfNotificationRequester()
  }

  registerServiceWorker() {
    if (navigator.serviceWorker) {
      return navigator.serviceWorker
        .register('/service-worker.js', { scope: '/' })
        .then(() => navigator.serviceWorker.ready)
        .then((registration) => {
          console.log(
            '[ServiceWorkerController]',
            'Service worker registered!'
          );
          return registration;
        });
    }
  }

  handleDisplayOfNotificationRequester() {
    const currentPermission = Notification.permission;

    if (currentPermission === 'default') {
      // Do not show the banner if the user has granted or denied permissions
      this.notificationRequesterTarget.classList.remove('hidden')
    }
  }

  enableNotifications() {
    this.disableNotificationButton()

    Notification.requestPermission()
      .then((permission) => {
        if (permission === 'granted') {
          this.notificationRequesterTarget.classList.add('hidden')
          // this.subscribeToPushNotifications();
        } else if (permission === 'denied') {
          this.notificationRequesterTarget.classList.add('hidden')
        } else if (permission === 'default') {
          this.enableNotificationButton()
        }
      })
      .catch((_err) => {
        this.enableNotificationButton()
      });
  }

  subscribeToPushNotifications() {
    this.registerServiceWorker()
      .then((registration) => {
        return registration.pushManager.subscribe({
          userVisibleOnly: true,
          applicationServerKey: window.vapidPublicKey,
        });
      })
      .then((subscription) => {
        // TODO: send this to the server
        console.log(subscription);
      });
  }

  disableNotificationButton() {
    this.enableNotificationButtonTarget.disabled = true;
    this.enableNotificationButtonTarget.classList.add('bg-slate-300');
    this.enableNotificationButtonTarget.innerHTML = 'Waiting';
  }

  enableNotificationButton() {
    this.enableNotificationButtonTarget.disabled = false;
    this.enableNotificationButtonTarget.classList.remove('bg-slate-300');
    this.enableNotificationButtonTarget.innerHTML = 'Notify me';
  }
}
