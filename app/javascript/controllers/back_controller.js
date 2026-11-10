import { Controller } from '@hotwired/stimulus'

// Goes back through history when we came from within the app, so the previous
// page keeps its scroll position and the transition plays in reverse. A fresh
// visit (such as a shared link) follows the link instead.
export default class extends Controller {
  go (event) {
    if (window.history.state?.turbo?.restorationIndex > 0) {
      event.preventDefault()
      window.history.back()
    }
  }
}
