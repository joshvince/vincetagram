import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['avatar', 'newPost', 'userList', 'logOutForm', 'cancelButton'];

  openLogOutForm() {
    this.avatarTarget.classList.add('hidden');
    if (this.hasNewPostTarget) {
      this.newPostTarget.classList.add('hidden');
    }
    if (this.hasUserListTarget) {
      this.userListTarget.classList.add('hidden');
    }
    this.logOutFormTarget.classList.remove('hidden');
  }

  closeLogOutForm() {
    this.avatarTarget.classList.remove('hidden');
    if (this.hasNewPostTarget) {
      this.newPostTarget.classList.remove('hidden');
    }
    if (this.hasUserListTarget) {
      this.userListTarget.classList.remove('hidden');
    }
    this.logOutFormTarget.classList.add('hidden');
  }
}
