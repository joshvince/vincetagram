import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['shareLink', 'loadingIndicator', 'post', 'image']
  static values = {
    url: String
  }

  connect () {
    if (this.imageTarget.complete) {
      this.displayPost()
    }
  }

  displayPost () {
    this.postTarget.classList.remove('hidden')
    this.loadingIndicatorTarget.remove()
  }

  copyLinkToClipboard () {
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
