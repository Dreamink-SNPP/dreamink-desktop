// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"

// Register service worker for offline support
if ('serviceWorker' in navigator) {
  navigator.serviceWorker.register('/service-worker')
    .then(registration => console.log('ServiceWorker registered:', registration))
    .catch(error => console.log('ServiceWorker registration failed:', error));
}
