import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  static targets = ['media']

  mediaTargetConnected (media) {
    const element = media.querySelector('img, video')
    if (element?.complete || element?.readyState > 0) this.reveal()
  }

  reveal () {
    this.mediaTarget.classList.add('is-sharp')
  }

  // Names the tapped photo so the view transition morphs it into the post page.
  expand () {
    document.querySelectorAll('.media').forEach((media) => { media.style.viewTransitionName = '' })
    this.mediaTarget.style.viewTransitionName = 'hero'
  }
}
