import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['shareLink']
  static values = {
    url: String
  }

  copyLinkToClipboard() {
    const currentHTML = this.shareLinkTarget.innerHTML

    navigator.clipboard.writeText(this.urlValue)

    this.shareLinkTarget.innerHTML = 'copied to clipboard!'
    this.shareLinkTarget.classList.add('text-green-500')

    setTimeout(() => {
      this.shareLinkTarget.innerHTML = currentHTML
      this.shareLinkTarget.classList.remove('text-green-500')
    }, 1000)
  }
};
