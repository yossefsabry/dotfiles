// ==UserScript==
// @name         Falkon Vimium-Lite
// @namespace    local
// @version      1.1.2
// @description  Basic vim-style navigation + link hints for Falkon via GreaseMonkey
// @match        *://*/*
// @run-at       document-start
// @grant        GM_getValue
// @grant        GM_setValue
// ==/UserScript==

(function () {
  "use strict";

  const TAB_STORE_KEY = "__vimium_lite_tabs__";
  const TAB_ID_KEY = "__vimium_lite_tab_id__";
  const TAB_TTL_MS = 3 * 60 * 1000;
  const HEARTBEAT_MS = 10000;
  const RESULT_LIMIT = 8;
  const SEARCH_URL = "https://www.google.com/search?q=";
  const BAR_DEBOUNCE_MS = 90;

  let tabId = null;
  let barOpen = false;
  let bar = null;
  let barInput = null;
  let barList = null;
  let barResults = [];
  let barItems = [];
  let selectedIndex = 0;
  let inputTimer = null;
  let lastFocus = null;

  // Don’t hijack keys while typing in inputs/textareas/contenteditable.
  function isTypingTarget(el) {
    if (!el) return false;
    const tag = el.tagName ? el.tagName.toLowerCase() : "";
    return tag === "input" || tag === "textarea" || el.isContentEditable;
  }

  function normalizeText(text) {
    return (text || "").toLowerCase();
  }

  function getTabId() {
    if (tabId) return tabId;
    try {
      tabId = sessionStorage.getItem(TAB_ID_KEY);
      if (!tabId) {
        tabId = `${Date.now().toString(36)}-${Math.random().toString(36).slice(2, 8)}`;
        sessionStorage.setItem(TAB_ID_KEY, tabId);
      }
    } catch (e) {
      tabId = `${Date.now().toString(36)}-${Math.random().toString(36).slice(2, 8)}`;
    }
    return tabId;
  }

  function loadTabs() {
    if (typeof GM_getValue !== "function") return [];
    try {
      const raw = GM_getValue(TAB_STORE_KEY, "[]");
      if (Array.isArray(raw)) return raw;
      if (typeof raw === "string") return JSON.parse(raw);
    } catch (e) {
    }
    return [];
  }

  function saveTabs(tabs) {
    if (typeof GM_setValue !== "function") return;
    try {
      GM_setValue(TAB_STORE_KEY, JSON.stringify(tabs));
    } catch (e) {
    }
  }

  function getTabEntry() {
    return {
      id: getTabId(),
      title: document.title || location.href,
      url: location.href,
      lastSeen: Date.now()
    };
  }

  function updateTabRegistry() {
    const entry = getTabEntry();
    const tabs = loadTabs().filter((t) => t && t.id && t.url);
    const index = tabs.findIndex((t) => t.id === entry.id);
    if (index >= 0) {
      tabs[index] = entry;
    } else {
      tabs.push(entry);
    }
    saveTabs(tabs);
  }

  function removeTabRegistry() {
    const id = getTabId();
    const tabs = loadTabs().filter((t) => t && t.id !== id);
    saveTabs(tabs);
  }

  function purgeTabs(tabs, now) {
    const cutoff = now - TAB_TTL_MS;
    return tabs.filter((t) => t && t.url && typeof t.lastSeen === "number" && t.lastSeen >= cutoff);
  }

  function getFreshTabs() {
    const now = Date.now();
    const tabs = loadTabs();
    const fresh = purgeTabs(tabs, now);
    if (fresh.length !== tabs.length) {
      saveTabs(fresh);
    }
    fresh.sort((a, b) => b.lastSeen - a.lastSeen);
    return fresh;
  }

  function scheduleInitialUpdate() {
    if (document.readyState === "complete" || document.readyState === "interactive") {
      updateTabRegistry();
      return;
    }
    document.addEventListener("DOMContentLoaded", () => updateTabRegistry(), { once: true });
  }

  scheduleInitialUpdate();
  document.addEventListener("visibilitychange", () => {
    if (document.visibilityState === "visible") {
      updateTabRegistry();
    }
  });
  window.addEventListener("beforeunload", removeTabRegistry);
  setInterval(() => {
    if (document.visibilityState === "visible") {
      updateTabRegistry();
    }
  }, HEARTBEAT_MS);

  function ensureBar() {
    if (bar) return;

    bar = document.createElement("div");
    bar.id = "__vimium_lite_cmd__";
    bar.style.cssText = [
      "position:fixed",
      "top:8px",
      "left:50%",
      "transform:translateX(-50%)",
      "width:94vw",
      "max-width:720px",
      "background:#fdfdfd",
      "border:1px solid #c9c9c9",
      "border-radius:8px",
      "box-shadow:0 6px 24px rgba(0,0,0,0.18)",
      "z-index:2147483647",
      "font:14px/1.35 \"JetBrains Mono\", \"Iosevka\", monospace",
      "color:#111",
      "display:none",
      "box-sizing:border-box"
    ].join(";");

    barInput = document.createElement("input");
    barInput.type = "text";
    barInput.autocomplete = "off";
    barInput.spellcheck = false;
    barInput.placeholder = "Search tabs or web";
    barInput.style.cssText = [
      "width:100%",
      "box-sizing:border-box",
      "padding:8px 10px",
      "border:0",
      "border-bottom:1px solid #ddd",
      "outline:none",
      "background:#fff",
      "font:inherit"
    ].join(";");

    barList = document.createElement("div");
    barList.style.cssText = [
      "max-height:260px",
      "overflow-y:auto"
    ].join(";");

    bar.appendChild(barInput);
    bar.appendChild(barList);

    const root = document.documentElement || document.body;
    if (root) {
      root.appendChild(bar);
    } else {
      document.addEventListener("DOMContentLoaded", () => {
        (document.documentElement || document.body).appendChild(bar);
      }, { once: true });
    }

    barInput.addEventListener("input", scheduleUpdateResults);
    barInput.addEventListener("keydown", onBarKeydown);
  }

  function scheduleUpdateResults() {
    if (inputTimer) clearTimeout(inputTimer);
    inputTimer = setTimeout(updateResults, BAR_DEBOUNCE_MS);
  }

  function buildResults(query) {
    const trimmed = query.trim();
    const q = normalizeText(trimmed);
    const tabs = getFreshTabs();
    let filtered = tabs;
    if (q) {
      filtered = tabs.filter((t) => {
        const hay = `${normalizeText(t.title)} ${normalizeText(t.url)}`;
        return hay.indexOf(q) !== -1;
      });
    }
    const results = filtered.slice(0, RESULT_LIMIT).map((t) => ({
      type: "tab",
      title: t.title || t.url,
      url: t.url
    }));
    if (trimmed) {
      results.push({ type: "search", query: trimmed });
    }
    return results;
  }

  function renderResults() {
    barList.innerHTML = "";
    barItems = [];

    if (!barResults.length) {
      const empty = document.createElement("div");
      empty.textContent = "No recent tabs";
      empty.style.cssText = "padding:8px 10px;color:#777;";
      barList.appendChild(empty);
      return;
    }

    barResults.forEach((result, index) => {
      const item = document.createElement("div");
      item.style.cssText = "padding:6px 10px;border-top:1px solid #eee;cursor:default;";

      const title = document.createElement("div");
      if (result.type === "tab") {
        title.textContent = result.title || result.url;
        title.style.cssText = "font-weight:600;";
        const url = document.createElement("div");
        url.textContent = result.url;
        url.style.cssText = "font-size:12px;color:#555;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;";
        item.appendChild(title);
        item.appendChild(url);
      } else {
        title.textContent = `Search web for: ${result.query}`;
        title.style.cssText = "font-weight:500;color:#333;";
        item.appendChild(title);
      }

      item.addEventListener("mouseenter", () => {
        selectedIndex = index;
        updateSelection();
      });
      item.addEventListener("mousedown", (e) => {
        e.preventDefault();
        selectedIndex = index;
        activateSelection(e.ctrlKey || e.metaKey);
      });

      barItems.push(item);
      barList.appendChild(item);
    });

    updateSelection();
  }

  function updateSelection() {
    barItems.forEach((item, index) => {
      item.style.background = index === selectedIndex ? "#e6f0ff" : "#fff";
    });
    ensureSelectedVisible();
  }

  function ensureSelectedVisible() {
    const item = barItems[selectedIndex];
    if (!item) return;
    const listRect = barList.getBoundingClientRect();
    const itemRect = item.getBoundingClientRect();
    if (itemRect.top < listRect.top) {
      barList.scrollTop -= (listRect.top - itemRect.top);
    } else if (itemRect.bottom > listRect.bottom) {
      barList.scrollTop += (itemRect.bottom - listRect.bottom);
    }
  }

  function updateResults() {
    barResults = buildResults(barInput.value);
    selectedIndex = 0;
    renderResults();
  }

  function openUrl(url, newTab) {
    if (!url) return;
    if (newTab) {
      window.open(url, "_blank", "noopener,noreferrer");
    } else {
      window.location.href = url;
    }
  }

  function activateSelection(openInNewTab) {
    if (!barResults.length) return;
    const item = barResults[selectedIndex] || barResults[0];
    if (!item) return;
    if (item.type === "tab") {
      openUrl(item.url, openInNewTab);
    } else if (item.type === "search") {
      openUrl(SEARCH_URL + encodeURIComponent(item.query), openInNewTab);
    }
    closeBar();
  }

  function onBarKeydown(e) {
    if (e.key === "Escape") {
      e.preventDefault();
      closeBar();
      return;
    }
    if (e.key === "ArrowDown") {
      e.preventDefault();
      if (barResults.length) {
        selectedIndex = (selectedIndex + 1) % barResults.length;
        updateSelection();
      }
      return;
    }
    if (e.key === "ArrowUp") {
      e.preventDefault();
      if (barResults.length) {
        selectedIndex = (selectedIndex - 1 + barResults.length) % barResults.length;
        updateSelection();
      }
      return;
    }
    if (e.key === "Enter") {
      e.preventDefault();
      activateSelection(e.ctrlKey || e.metaKey);
    }
  }

  function openBar() {
    ensureBar();
    if (!bar) return;
    if (hintMode) cleanupHints();
    updateTabRegistry();
    lastFocus = document.activeElement;
    bar.style.display = "block";
    barOpen = true;
    barInput.value = "";
    updateResults();
    barInput.focus();
    barInput.select();
  }

  function closeBar() {
    if (!bar) return;
    barOpen = false;
    bar.style.display = "none";
    barInput.value = "";
    barList.innerHTML = "";
    barResults = [];
    barItems = [];
    selectedIndex = 0;
    if (lastFocus && typeof lastFocus.focus === "function") {
      lastFocus.focus();
    }
  }

  function toggleBar() {
    if (barOpen) {
      closeBar();
    } else {
      openBar();
    }
  }

  // -------- Basic motions --------
  function scrollByLines(lines) {
    window.scrollBy({ top: lines * 40, left: 0, behavior: "instant" });
  }
  function scrollToTop() { window.scrollTo({ top: 0, behavior: "instant" }); }
  function scrollToBottom() { window.scrollTo({ top: document.body.scrollHeight, behavior: "instant" }); }

  // -------- Link hints (numeric, simple) --------
  let hintMode = false;
  let overlay = null;
  let hints = [];
  let typed = "";

  function cleanupHints() {
    hintMode = false;
    typed = "";
    hints = [];
    if (overlay) overlay.remove();
    overlay = null;
  }

  function clickableElements() {
    const selectors = [
      "a[href]",
      "button",
      "input:not([type='hidden'])",
      "textarea",
      "select",
      "[role='button']",
      "[onclick]"
    ];
    const nodes = Array.from(document.querySelectorAll(selectors.join(",")));

    // Only visible + in viewport-ish
    return nodes.filter(el => {
      const r = el.getBoundingClientRect();
      const visible = r.width > 0 && r.height > 0;
      const inView = r.bottom >= 0 && r.right >= 0 && r.top <= (window.innerHeight || 0) && r.left <= (window.innerWidth || 0);
      const style = window.getComputedStyle(el);
      const notHidden = style.visibility !== "hidden" && style.display !== "none" && style.opacity !== "0";
      return visible && inView && notHidden;
    });
  }

  function makeOverlay() {
    overlay = document.createElement("div");
    overlay.id = "__vimium_lite_overlay__";
    overlay.style.position = "fixed";
    overlay.style.left = "0";
    overlay.style.top = "0";
    overlay.style.width = "100%";
    overlay.style.height = "100%";
    overlay.style.zIndex = "2147483647";
    overlay.style.pointerEvents = "none";
    document.documentElement.appendChild(overlay);
  }

  function addHint(label, rect) {
    const tag = document.createElement("div");
    tag.textContent = label;
    tag.style.position = "fixed";
    tag.style.left = `${Math.max(0, rect.left)}px`;
    tag.style.top = `${Math.max(0, rect.top)}px`;
    tag.style.padding = "1px 4px";
    tag.style.font = "12px monospace";
    tag.style.border = "1px solid #000";
    tag.style.borderRadius = "3px";
    tag.style.background = "yellow";
    tag.style.color = "#000";
    tag.style.pointerEvents = "none";
    overlay.appendChild(tag);
    return tag;
  }

  function enterHintMode() {
    if (hintMode) return;
    hintMode = true;
    typed = "";
    makeOverlay();

    const els = clickableElements();
    hints = els.map((el, i) => {
      const rect = el.getBoundingClientRect();
      const label = String(i + 1);
      const tag = addHint(label, rect);
      return { el, label, tag };
    });

    if (hints.length === 0) cleanupHints();
  }

  function updateHintHighlight() {
    for (const h of hints) {
      const match = typed.length === 0 || h.label.startsWith(typed);
      h.tag.style.opacity = match ? "1" : "0.15";
    }
  }

  function activateIfUnique() {
    const matches = hints.filter(h => h.label.startsWith(typed));
    if (matches.length === 1 && matches[0].label === typed) {
      matches[0].el.click();
      cleanupHints();
    }
  }

  function isCommandBarToggle(e) {
    return e.ctrlKey && !e.altKey && !e.metaKey && e.code === "Semicolon";
  }

  let lastG = 0;

  document.addEventListener("keydown", (e) => {
    if (isCommandBarToggle(e)) {
      e.preventDefault();
      toggleBar();
      return;
    }

    if (barOpen) return;

    // History shortcuts (Ctrl+Alt+H/L)
    if (e.ctrlKey && e.altKey && (e.key === "h" || e.key === "H")) {
      e.preventDefault();
      history.back();
      return;
    }
    if (e.ctrlKey && e.altKey && (e.key === "l" || e.key === "L")) {
      e.preventDefault();
      history.forward();
      return;
    }

    if (isTypingTarget(document.activeElement)) return;

    // Hint mode handling
    if (hintMode) {
      if (e.key === "Escape") { e.preventDefault(); cleanupHints(); return; }
      if (e.key >= "0" && e.key <= "9") {
        e.preventDefault();
        typed += e.key;
        updateHintHighlight();
        activateIfUnique();
        return;
      }
      if (e.key === "Backspace") {
        e.preventDefault();
        typed = typed.slice(0, -1);
        updateHintHighlight();
        return;
      }
      // Block other keys while in hint mode
      e.preventDefault();
      return;
    }

    // Normal mode bindings
    switch (e.key) {
      case "j": e.preventDefault(); scrollByLines(+3); break;
      case "k": e.preventDefault(); scrollByLines(-3); break;
      case "g": {
        const now = Date.now();
        if (now - lastG < 400) {
          e.preventDefault();
          scrollToTop();
          lastG = 0;
        } else {
          lastG = now;
        }
        break;
      }
      case "G": e.preventDefault(); scrollToBottom(); break;
      case "h": e.preventDefault(); history.back(); break;
      case "l": e.preventDefault(); history.forward(); break;
      case "f": e.preventDefault(); enterHintMode(); break;
    }
  }, true);
})();
