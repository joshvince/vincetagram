import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static values = { text: String }

  async copy () {
    try {
      await navigator.clipboard.writeText(this.textValue)
    } catch {
      if (!this.copyWithSelection()) return
    }

    this.element.classList.add('is-copied')
    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => this.element.classList.remove('is-copied'), 1600)
  }

  // Older browsers and some in-app web views refuse the async clipboard API.
  copyWithSelection () {
    const field = document.createElement('textarea')
    field.value = this.textValue
    field.setAttribute('readonly', '')
    field.style.position = 'fixed'
    field.style.opacity = '0'
    document.body.append(field)
    field.select()
    const copied = document.execCommand('copy')
    field.remove()
    return copied
  }
}
