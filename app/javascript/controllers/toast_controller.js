import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  connect () {
    requestAnimationFrame(() => this.element.classList.add('is-on'))
    this.timeout = setTimeout(() => this.element.classList.remove('is-on'), 2800)
  }

  disconnect () {
    clearTimeout(this.timeout)
  }
}
