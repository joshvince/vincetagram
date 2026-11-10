import { Controller } from '@hotwired/stimulus'

// Swaps between stacked alternatives in place, such as a button and its confirmation.
export default class extends Controller {
  static targets = ['item']

  toggle () {
    this.itemTargets.forEach((item) => { item.hidden = !item.hidden })
    this.itemTargets.find((item) => !item.hidden)?.querySelector('button')?.focus()
  }
}
