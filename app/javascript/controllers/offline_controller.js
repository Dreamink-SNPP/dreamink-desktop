import { Controller } from "@hotwired/stimulus"

// Displays an offline indicator when the network connection is lost
export default class extends Controller {
  connect() {
    this.updateStatus()
    window.addEventListener('online', this.handleOnline)
    window.addEventListener('offline', this.handleOffline)
  }

  disconnect() {
    window.removeEventListener('online', this.handleOnline)
    window.removeEventListener('offline', this.handleOffline)
  }

  handleOnline = () => {
    this.element.classList.add('hidden')
  }

  handleOffline = () => {
    this.element.classList.remove('hidden')
  }

  updateStatus() {
    if (navigator.onLine) {
      this.element.classList.add('hidden')
    } else {
      this.element.classList.remove('hidden')
    }
  }
}
