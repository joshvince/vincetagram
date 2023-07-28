import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['token'];

  connect() {
    this.token = this.tokenTarget.innerHTML.trim();
  }

  copyTokenToClipboard() {
    if (this.token.length > 1) {
      navigator.clipboard.writeText(this.token);
      this.tokenTarget.innerHTML = 'Copied!';

      setTimeout(() => {
        this.tokenTarget.innerHTML = this.token;
      }, 1000);
    }
  }
}
