// Dreamink Desktop - Offline Service Worker
// Provides offline functionality for the desktop application

const CACHE_VERSION = 'dreamink-v1';
const RUNTIME_CACHE = 'dreamink-runtime';

// Assets to cache on install (critical paths)
const PRECACHE_URLS = [
  '/',
  '/login',
  '/assets/application.js',
  '/assets/application.css',
  '/assets/tailwind.css',
  '/assets/custom_colors.css',
  '/icon.png',
  '/icon.svg'
];

// Install event - precache critical assets
self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_VERSION)
      .then(cache => cache.addAll(PRECACHE_URLS))
      .then(() => self.skipWaiting())
  );
});

// Activate event - clean old caches
self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then(cacheNames => {
      return Promise.all(
        cacheNames
          .filter(cacheName => cacheName !== CACHE_VERSION && cacheName !== RUNTIME_CACHE)
          .map(cacheName => caches.delete(cacheName))
      );
    }).then(() => self.clients.claim())
  );
});

// Fetch event - network-first for HTML, cache-first for assets
self.addEventListener('fetch', (event) => {
  const { request } = event;
  const url = new URL(request.url);

  // Skip cross-origin requests
  if (url.origin !== self.location.origin) {
    return;
  }

  // Network-first for HTML/API requests (need fresh data)
  if (request.headers.get('accept')?.includes('text/html') ||
      request.method !== 'GET') {
    event.respondWith(
      fetch(request)
        .then(response => {
          // Cache successful responses
          if (response.ok) {
            const clonedResponse = response.clone();
            caches.open(RUNTIME_CACHE)
              .then(cache => cache.put(request, clonedResponse));
          }
          return response;
        })
        .catch(() => {
          // Fallback to cache if offline
          return caches.match(request);
        })
    );
    return;
  }

  // Cache-first for static assets (CSS, JS, images)
  event.respondWith(
    caches.match(request)
      .then(cachedResponse => {
        if (cachedResponse) {
          return cachedResponse;
        }
        return fetch(request).then(response => {
          // Cache successful fetches
          if (response.ok) {
            return caches.open(RUNTIME_CACHE).then(cache => {
              cache.put(request, response.clone());
              return response;
            });
          }
          return response;
        });
      })
  );
});
