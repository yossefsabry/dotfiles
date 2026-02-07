// ==UserScript==
// @name         X/Youtube/TikTok Lite (Clean)
// @namespace    local
// @version      1.0.0
// @description  Lightweight download helpers for X, YouTube, and TikTok. No tracking or affiliate code.
// @match        *://x.com/*
// @match        *://twitter.com/*
// @match        *://mobile.x.com/*
// @match        *://www.youtube.com/*
// @match        *://music.youtube.com/*
// @match        *://www.tiktok.com/*
// @run-at       document-start
// @grant        GM_download
// @grant        GM_openInTab
// @grant        GM.openInTab
// ==/UserScript==

(function () {
  "use strict";

  if (window.top !== window.self) return;

  const host = window.location.host;
  const isX = /(^|\.)x\.com$|(^|\.)twitter\.com$/.test(host) || host === "mobile.x.com";
  const isYoutube = /(^|\.)youtube\.com$/.test(host) || host === "music.youtube.com";
  const isTiktok = /(^|\.)tiktok\.com$/.test(host);

  if (!isX && !isYoutube && !isTiktok) return;

  function openInTab(url) {
    if (!url) return;
    if (typeof GM_openInTab === "function") {
      GM_openInTab(url, { active: true, insert: true, setParent: true });
    } else if (typeof GM !== "undefined" && typeof GM.openInTab === "function") {
      GM.openInTab(url, { active: true, insert: true, setParent: true });
    } else {
      window.open(url, "_blank", "noopener,noreferrer");
    }
  }

  function sanitizeFilename(name) {
    return (name || "download")
      .replace(/[\\/\?%\*:\|\"<>\r\n]/g, "_")
      .slice(0, 80);
  }

  function getExtension(url, fallback) {
    try {
      const pathname = new URL(url).pathname;
      const ext = pathname.split(".").pop();
      return ext ? ext.split("?")[0] : fallback;
    } catch (e) {
      return fallback;
    }
  }

  // ---------------- X (Twitter) ----------------
  const X = {
    mediaMap: new Map(),
    init: function () {
      this.injectStyle();
      this.hookXHR();
      this.hookFetch();
      this.observe();
    },
    injectStyle: function () {
      const style = document.createElement("style");
      style.textContent = [
        ".x-lite-download-btn{margin-left:8px;padding:2px 8px;border-radius:999px;border:1px solid #1da1f2;background:transparent;color:#1da1f2;font-size:12px;cursor:pointer}",
        ".x-lite-download-btn:hover{background:rgba(29,161,242,0.1)}",
        ".x-lite-download-btn[disabled]{opacity:0.6;cursor:default}"
      ].join("\n");
      (document.head || document.documentElement).appendChild(style);
    },
    hookXHR: function () {
      const originalOpen = XMLHttpRequest.prototype.open;
      const originalSend = XMLHttpRequest.prototype.send;
      XMLHttpRequest.prototype.open = function (method, url) {
        this._xUrl = url;
        return originalOpen.apply(this, arguments);
      };
      XMLHttpRequest.prototype.send = function () {
        this.addEventListener("load", () => {
          if (!this._xUrl) return;
          if (typeof this.responseText !== "string") return;
          if (!X.shouldParseUrl(this._xUrl)) return;
          X.extractMediaFromText(this.responseText);
        });
        return originalSend.apply(this, arguments);
      };
    },
    hookFetch: function () {
      if (typeof window.fetch !== "function") return;
      const originalFetch = window.fetch;
      window.fetch = function () {
        return originalFetch.apply(this, arguments).then((response) => {
          try {
            const request = arguments[0];
            const url = typeof request === "string" ? request : request.url;
            if (!url || !X.shouldParseUrl(url)) return response;
            const contentType = response.headers.get("content-type") || "";
            if (contentType.indexOf("application/json") === -1) return response;
            response.clone().text().then((text) => X.extractMediaFromText(text)).catch(() => {});
          } catch (e) {
          }
          return response;
        });
      };
    },
    shouldParseUrl: function (url) {
      return /\/graphql\/|TweetResultByRestId|UserTweets|UserMedia|HomeTimeline|SearchTimeline/i.test(url);
    },
    extractMediaFromText: function (responseText) {
      let data = null;
      try {
        data = JSON.parse(responseText);
      } catch (e) {
        return;
      }
      const entities = [];
      this.findEntities(data, entities);
      entities.forEach((entity) => this.addEntityMedia(entity));
    },
    findEntities: function (node, out) {
      if (!node || typeof node !== "object") return;
      if (Array.isArray(node)) {
        node.forEach((item) => this.findEntities(item, out));
        return;
      }
      if (node.extended_entities && node.extended_entities.media) {
        out.push(node);
      }
      for (const key in node) {
        if (Object.prototype.hasOwnProperty.call(node, key)) {
          this.findEntities(node[key], out);
        }
      }
    },
    getEntityId: function (entity) {
      return entity.id_str || entity.rest_id || entity.tweet_id || entity.conversation_id_str || entity.conversation_id || null;
    },
    addEntityMedia: function (entity) {
      const entityId = this.getEntityId(entity);
      if (!entityId) return;

      const text = (entity.full_text || entity.text || "").split("https://t.co")[0].trim();
      const existing = this.mediaMap.get(String(entityId)) || { id: String(entityId), text: text, videos: [], photos: [] };

      const media = entity.extended_entities?.media || [];
      media.forEach((item) => {
        if (item.type === "photo" && item.media_url_https) {
          existing.photos.push(item.media_url_https);
        }
        if ((item.type === "video" || item.type === "animated_gif") && item.video_info?.variants) {
          const best = item.video_info.variants
            .filter((v) => v.content_type === "video/mp4")
            .sort((a, b) => (b.bitrate || 0) - (a.bitrate || 0))[0];
          if (best && best.url) existing.videos.push(best.url);
        }
      });

      this.mediaMap.set(String(entityId), existing);
    },
    observe: function () {
      const onNode = (node) => {
        if (!node || node.nodeType !== 1) return;
        const article = node.matches("article") ? node : node.querySelector("article");
        if (article) {
          this.addDownloadButton(article);
          this.updateTimeTitles(article);
        }
      };
      const observer = new MutationObserver((mutations) => {
        mutations.forEach((mutation) => {
          mutation.addedNodes.forEach(onNode);
        });
      });
      const start = () => observer.observe(document.body, { childList: true, subtree: true });
      if (document.body) start();
      else document.addEventListener("DOMContentLoaded", start, { once: true });
    },
    updateTimeTitles: function (article) {
      article.querySelectorAll("time[datetime]").forEach((timeEl) => {
        const dt = timeEl.getAttribute("datetime");
        if (!dt) return;
        const date = new Date(dt);
        if (isNaN(date.getTime())) return;
        timeEl.title = date.toLocaleString();
      });
    },
    extractStatusIds: function (article) {
      const ids = new Set();
      article.querySelectorAll('a[href*="/status/"]').forEach((link) => {
        const match = link.href.match(/\/status\/(\d+)/);
        if (match && match[1]) ids.add(match[1]);
      });
      return Array.from(ids);
    },
    addDownloadButton: function (article) {
      if (article.dataset.xLiteDl === "1") return;
      const statusIds = this.extractStatusIds(article);
      if (!statusIds.length) return;
      const actionGroup = article.querySelector('div[role="group"]');
      if (!actionGroup) return;

      const btn = document.createElement("button");
      btn.type = "button";
      btn.className = "x-lite-download-btn";
      btn.textContent = "DL";
      btn.title = "Download media";
      btn.addEventListener("click", () => this.handleDownload(btn, statusIds));

      actionGroup.appendChild(btn);
      article.dataset.xLiteDl = "1";
    },
    handleDownload: function (btn, statusIds) {
      const mediaItems = [];
      statusIds.forEach((id) => {
        const item = this.mediaMap.get(String(id));
        if (item) mediaItems.push(item);
      });

      if (!mediaItems.length) {
        btn.textContent = "No media";
        btn.disabled = true;
        setTimeout(() => {
          btn.textContent = "DL";
          btn.disabled = false;
        }, 1200);
        return;
      }

      btn.textContent = "...";
      btn.disabled = true;

      const downloads = [];
      mediaItems.forEach((item) => {
        const base = sanitizeFilename(item.text || item.id);
        item.videos.forEach((url, index) => {
          const name = `${base}-video-${index + 1}.${getExtension(url, "mp4")}`;
          downloads.push({ url, name });
        });
        item.photos.forEach((url, index) => {
          const name = `${base}-photo-${index + 1}.${getExtension(url, "jpg")}`;
          downloads.push({ url, name });
        });
      });

      let done = 0;
      downloads.forEach((d) => {
        if (typeof GM_download === "function") {
          GM_download({
            url: d.url,
            name: d.name,
            onload: () => {
              done += 1;
              if (done === downloads.length) {
                btn.textContent = "DL";
                btn.disabled = false;
              }
            },
            onerror: () => {
              done += 1;
              if (done === downloads.length) {
                btn.textContent = "DL";
                btn.disabled = false;
              }
            }
          });
        } else {
          openInTab(d.url);
          done += 1;
        }
      });

      if (!downloads.length) {
        btn.textContent = "No media";
        btn.disabled = true;
        setTimeout(() => {
          btn.textContent = "DL";
          btn.disabled = false;
        }, 1200);
      }
    }
  };

  // ---------------- YouTube ----------------
  function initYoutube() {
    const buttonId = "__yt_lite_download_btn__";
    const onReady = (cb) => {
      if (document.body) cb();
      else document.addEventListener("DOMContentLoaded", cb, { once: true });
    };
    const getVideoUrl = () => {
      const url = new URL(window.location.href);
      const v = url.searchParams.get("v");
      if (v && window.location.pathname === "/watch") {
        return "https://www.youtube.com/watch?v=" + v;
      }
      if (window.location.pathname.indexOf("/shorts/") === 0) {
        const id = window.location.pathname.split("/shorts/")[1] || "";
        const cleanId = id.split(/[?#]/)[0];
        if (cleanId) return "https://www.youtube.com/shorts/" + cleanId;
      }
      return "";
    };
    const ensureButton = () => {
      let btn = document.getElementById(buttonId);
      if (btn) return btn;
      btn = document.createElement("button");
      btn.id = buttonId;
      btn.type = "button";
      btn.textContent = "Download";
      btn.title = "Download via TikFork";
      btn.style.cssText = [
        "position:fixed",
        "top:10px",
        "right:12px",
        "z-index:2147483647",
        "background:#ff0000",
        "color:#fff",
        "border:0",
        "border-radius:999px",
        "padding:6px 12px",
        "font:12px/1.2 sans-serif",
        "cursor:pointer",
        "box-shadow:0 4px 10px rgba(0,0,0,0.2)"
      ].join(";");
      btn.addEventListener("click", () => {
        const videoUrl = btn.dataset.videoUrl || getVideoUrl();
        if (!videoUrl) return;
        const url = "https://www.tikfork.com/en/yt?s=10&url=" + encodeURIComponent(videoUrl);
        openInTab(url);
      });
      document.body.appendChild(btn);
      return btn;
    };
    const syncButton = () => {
      const videoUrl = getVideoUrl();
      const existing = document.getElementById(buttonId);
      if (!videoUrl) {
        if (existing) existing.remove();
        return;
      }
      const btn = ensureButton();
      btn.dataset.videoUrl = videoUrl;
    };
    const bindNavigation = () => {
      if (document.documentElement.dataset.ytLiteNavBound === "1") return;
      document.documentElement.dataset.ytLiteNavBound = "1";
      const handler = () => syncButton();
      document.addEventListener("yt-navigate-finish", handler);
      window.addEventListener("popstate", handler);
    };
    onReady(() => {
      bindNavigation();
      syncButton();
    });
  }

  // ---------------- TikTok ----------------
  function initTiktok() {
    const buttonId = "__tt_lite_download_btn__";
    const onReady = (cb) => {
      if (document.body) cb();
      else document.addEventListener("DOMContentLoaded", cb, { once: true });
    };
    onReady(() => {
      if (document.getElementById(buttonId)) return;
      const btn = document.createElement("button");
      btn.id = buttonId;
      btn.type = "button";
      btn.textContent = "Download";
      btn.title = "Download via TikFork";
      btn.style.cssText = [
        "position:fixed",
        "top:10px",
        "right:12px",
        "z-index:2147483647",
        "background:#111",
        "color:#fff",
        "border:0",
        "border-radius:999px",
        "padding:6px 12px",
        "font:12px/1.2 sans-serif",
        "cursor:pointer",
        "box-shadow:0 4px 10px rgba(0,0,0,0.2)"
      ].join(";");
      btn.addEventListener("click", () => {
        const url = "https://www.tikfork.com/en/tk?s=10&url=" + encodeURIComponent(window.location.href);
        openInTab(url);
      });
      document.body.appendChild(btn);
    });
  }

  if (isX) X.init();
  if (isYoutube) initYoutube();
  if (isTiktok) initTiktok();
})();
