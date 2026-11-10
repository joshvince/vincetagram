import { Controller } from '@hotwired/stimulus'

// Shrinks the large page title into a glass bar over the first 50px of scroll.
export default class extends Controller {
  connect () {
    this.update = this.update.bind(this)
    window.addEventListener('scroll', this.update, { passive: true })
    this.update()
  }

  disconnect () {
    window.removeEventListener('scroll', this.update)
  }

  update () {
    if (this.frame) return

    this.frame = requestAnimationFrame(() => {
      this.frame = null
      const progress = Math.min(Math.max(window.scrollY / 50, 0), 1)
      this.element.style.setProperty('--p', progress.toFixed(3))
    })
  }
}
