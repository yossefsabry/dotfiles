// ==UserScript==
// @name         YouTube Pause on Load
// @namespace    local
// @version      1.0.0
// @description  Prevent YouTube videos from auto-playing until user presses Play.
// @match        https://www.youtube.com/*
// @run-at       document-start
// ==/UserScript==

(function () {
  "use strict";

  const PAUSE_WINDOW_MS = 4000;
  const CHECK_INTERVAL_MS = 200;
  const USER_GRACE_MS = 1000;

  let lastUserInputAt = 0;

  function markUserInput() {
    lastUserInputAt = Date.now();
  }

  function pauseIfPlaying() {
    if (Date.now() - lastUserInputAt < USER_GRACE_MS) return;
    const video = document.querySelector("video");
    if (!video) return;
    video.autoplay = false;
    video.removeAttribute("autoplay");
    if (!video.paused) video.pause();
  }

  function pauseWithRetry() {
    const start = Date.now();
    const timer = setInterval(() => {
      pauseIfPlaying();
      if (Date.now() - start > PAUSE_WINDOW_MS) clearInterval(timer);
    }, CHECK_INTERVAL_MS);
  }

  function onNavigate() {
    pauseWithRetry();
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", pauseWithRetry, { once: true });
  } else {
    pauseWithRetry();
  }

  document.addEventListener("pointerdown", markUserInput, { capture: true, passive: true });
  document.addEventListener("keydown", markUserInput, { capture: true, passive: true });
  document.addEventListener("yt-navigate-start", onNavigate);
  document.addEventListener("yt-navigate-finish", onNavigate);
})();
