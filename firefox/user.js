// user.js
// Firefox Performance Optimization Profile

// --- HARDWARE ACCELERATION & WEBRENDER ---
// Enforce WebRender to offload rendering to the GPU for smoother scrolling and video playback
user_pref("gfx.webrender.all", true);
// Enable VA-API hardware video decoding (beneficial for Linux/Wayland setups)
user_pref("media.ffmpeg.vaapi.enabled", true);
// Enable Canvas 2D acceleration
user_pref("gfx.canvas.accelerated", true);
user_pref("gfx.canvas.accelerated.cache-items", 4096);
user_pref("gfx.canvas.accelerated.cache-size", 512);

// --- NETWORKING & PREDICTIVE ACTIONS ---
// Enable page prefetching so pages start loading before you click when hovering
user_pref("network.predictor.enabled", true);
user_pref("network.predictor.enable-prefetch", true);
// Disable DNS prefetch blocking
user_pref("network.dns.disablePrefetch", false);
// Enable link prefetching
user_pref("network.prefetch-next", true);
// Enable HTTP/3 for faster connections on supporting servers
user_pref("network.http.http3.enable", true);

// --- MEMORY & CACHE MANAGEMENT ---
// Disable disk cache to stop Firefox from constantly writing to your hard drive/SSD
user_pref("browser.cache.disk.enable", false);
// Force Firefox to hold cached content in RAM (much faster than disk access)
user_pref("browser.cache.memory.enable", true);
// Let Firefox dynamically manage the maximum RAM capacity for cache
user_pref("browser.cache.memory.capacity", -1);

// --- UI RESPONSIVENESS & ANIMATIONS ---
// Disable unnecessary UI animations, making the browser feel instantly responsive
user_pref("toolkit.cosmeticAnimations.enabled", false);
// Disable download animations
user_pref("browser.download.animateNotifications", false);

// --- DISK I/O OPTIMIZATIONS ---
// Reduce the frequency of saving session store data (tabs/history) to disk
// Default is every 15,000ms (15 sec). Changing to 60,000ms (1 minute).
user_pref("browser.sessionstore.interval", 60000);

// --- SYSTEM RESOURCES & TELEMETRY ---
// Disable Firefox telemetry to prevent background tracking, saving minor processing and network power
user_pref("datareporting.healthreport.uploadEnabled", false);
user_pref("toolkit.telemetry.enabled", false);
user_pref("toolkit.telemetry.unified", false);
user_pref("toolkit.telemetry.server", "data:,");
user_pref("toolkit.telemetry.archive.enabled", false);
user_pref("toolkit.telemetry.newProfilePing.enabled", false);
user_pref("toolkit.telemetry.shutdownPingSender.enabled", false);
user_pref("toolkit.telemetry.updatePing.enabled", false);
user_pref("toolkit.telemetry.bhrPing.enabled", false);
user_pref("toolkit.telemetry.firstShutdownPing.enabled", false);
user_pref("toolkit.telemetry.coverage.opt-out", true);

// --- POCKET & NEW TAB RESOURCES ---
// Disable pocket integration in your new tab to save processing when opening new tabs
user_pref("extensions.pocket.enabled", false);
user_pref("browser.newtabpage.activity-stream.section.highlights.includePocket", false);

// --- ADVANCED NETWORK & CONNECTION SETTINGS ---
// Increase the maximum concurrent HTTP connections for faster parallel loading of page assets
user_pref("network.http.max-connections", 900);
user_pref("network.http.max-persistent-connections-per-server", 10);
// Accelerate HTTPS connections by caching more TLS sessions
user_pref("network.ssl_tokens_cache_capacity", 10240);
// Enable TCP Fast Open to reduce connection setup time latency
user_pref("network.tcp.tcp_fastopen_enable", true);
// Enable TCP keepalive to maintain active connections
user_pref("network.tcp.tcp_keepalive_enable", true);
// Optimize the HTTP connection timeout (default is 90s, changing to 30s)
user_pref("network.http.connection-timeout", 30);
// Ensure HTTP/3 is strictly enabled for the fastest modern connections
user_pref("network.http.http3.enable", true);
// Enable DNS over HTTPS (DoH) via Cloudflare for faster and secure DNS lookups
user_pref("network.trr.mode", 2);
user_pref("network.trr.uri", "https://mozilla.cloudflare-dns.com/dns-query");

// --- EXTREME STARTUP & RENDERING SPEED ---
// Force paint to happen sooner (reduces initial blank screen time, default is 250ms)
user_pref("nglayout.initialpaint.delay", 5);
// Force Firefox to prioritize rendering over non-essential tasks
user_pref("content.notify.backoffcount", 5);
user_pref("content.notify.interval", 100000);
user_pref("content.notify.ontimer", true);
// Decrease timer interval to make JavaScript execution slightly more responsive
user_pref("dom.min_background_timeout_value", 10);
// Pre-connect to websites when hovering over links or typing in the URL bar
user_pref("network.http.speculative-parallel-limit", 6);
// Pre-resolve DNS when hovering over links
user_pref("network.dns.disablePrefetchFromHTTPS", false);
// Aggressively cache decoded images to RAM (faster picture rendering on heavy pages)
user_pref("image.mem.decode_bytes_at_a_time", 131072);
// Keep more images decoded in memory
user_pref("image.cache.size", 5242880);
