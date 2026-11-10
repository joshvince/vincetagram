import { Controller } from '@hotwired/stimulus'

// A bottom sheet on a <dialog> that springs up, and closes on the backdrop,
// Escape, or a downward drag of its handle.
export default class extends Controller {
  static targets = ['dialog']

  open () {
    this.dialogTarget.showModal()
    requestAnimationFrame(() => this.dialogTarget.classList.add('is-open'))
  }

  close () {
    const dialog = this.dialogTarget
    if (!dialog.open) return

    dialog.classList.remove('is-open', 'is-dragging')
    dialog.style.removeProperty('--drag')
    const finish = () => dialog.close()
    if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) return finish()

    dialog.addEventListener('transitionend', finish, { once: true })
    setTimeout(finish, 400)
  }

  closeOnBackdrop (event) {
    if (event.target === this.dialogTarget) this.close()
  }

  drag (event) {
    const dialog = this.dialogTarget
    const startY = event.clientY
    const startTime = event.timeStamp
    let distance = 0

    event.currentTarget.setPointerCapture(event.pointerId)
    dialog.classList.add('is-dragging')

    const move = (moveEvent) => {
      distance = Math.max(0, moveEvent.clientY - startY)
      dialog.style.setProperty('--drag', `${distance}px`)
    }
    const end = (endEvent) => {
      window.removeEventListener('pointermove', move)
      dialog.classList.remove('is-dragging')
      const velocity = distance / Math.max(endEvent.timeStamp - startTime, 1)
      if (distance > 120 || velocity > 0.6) {
        this.close()
      } else {
        dialog.style.removeProperty('--drag')
      }
    }

    window.addEventListener('pointermove', move)
    window.addEventListener('pointerup', end, { once: true })
    window.addEventListener('pointercancel', end, { once: true })
  }
}
