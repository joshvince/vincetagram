import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['avatar', 'newPost', 'logOutForm', 'cancelButton'];

  openLogOutForm() {
    this.avatarTarget.classList.add('hidden');
    this.newPostTarget.classList.add('hidden');
    this.logOutFormTarget.classList.remove('hidden');
  }

  closeLogOutForm() {
    this.avatarTarget.classList.remove('hidden');
    this.newPostTarget.classList.remove('hidden');
    this.logOutFormTarget.classList.add('hidden');
  }
}
