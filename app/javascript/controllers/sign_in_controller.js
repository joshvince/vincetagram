import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['entryPoint', 'inputForm'];

  toggleView() {
    this.inputFormTarget.classList.remove('hidden');
    this.entryPointTarget.classList.add('hidden');
  }
}
