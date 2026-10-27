import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['token'];

  copyTokenToClipboard() {
    const token = this.tokenTarget.textContent.trim();
    if (token === 'Copied!') return;

    navigator.clipboard.writeText(token);
    this.tokenTarget.textContent = 'Copied!';

    setTimeout(() => {
      this.tokenTarget.textContent = token;
    }, 1000);
  }
}
