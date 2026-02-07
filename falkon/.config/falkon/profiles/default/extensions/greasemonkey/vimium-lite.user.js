// ==UserScript==
// @name         Falkon Vimium-Lite
// @namespace    local
// @version      1.1.2
// @description  Basic vim-style navigation + link hints for Falkon via GreaseMonkey
// @match        *://*/*
// @run-at       document-start
// @grant        none
// ==/UserScript==

(function () {
  "use strict";

  // Don’t hijack keys while typing in inputs/textareas/contenteditable.
  function isTypingTarget(el) {
    if (!el) return false;
    const tag = el.tagName ? el.tagName.toLowerCase() : "";
    return tag === "input" || tag === "textarea" || el.isContentEditable;
  }
  // -------- Basic motions --------
  function scrollByLines(lines) {
    window.scrollBy({ top: lines * 40, left: 0, behavior: "instant" });
  }
  function scrollToTop() { window.scrollTo({ top: 0, behavior: "instant" }); }
  function scrollToBottom() { window.scrollTo({ top: document.body.scrollHeight, behavior: "instant" }); }

  // -------- Link hints (numeric, simple) --------
  let hintMode = false;
  let hintAction = "click";
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

  function clickableElements(action) {
    const selectors = action === "copy" ? ["a[href]"] : [
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

  function resolveLink(el) {
    if (!el) return "";
    let linkEl = null;
    if (typeof el.closest === "function") {
      linkEl = el.closest("a[href]");
    }
    if (!linkEl && el.tagName && el.tagName.toLowerCase() === "a") {
      linkEl = el;
    }
    const href = linkEl ? linkEl.getAttribute("href") : (el.getAttribute ? el.getAttribute("href") : "");
    if (!href) return "";
    try {
      return new URL(href, location.href).href;
    } catch (e) {
      return href;
    }
  }

  function legacyCopy(text) {
    const root = document.body || document.documentElement;
    if (!root) return;
    const ta = document.createElement("textarea");
    ta.value = text;
    ta.setAttribute("readonly", "");
    ta.style.position = "fixed";
    ta.style.left = "-9999px";
    ta.style.top = "0";
    ta.style.opacity = "0";
    root.appendChild(ta);
    ta.select();
    try {
      document.execCommand("copy");
    } catch (e) {
    }
    ta.remove();
  }

  function copyText(text) {
    if (!text) return;
    if (navigator.clipboard && typeof navigator.clipboard.writeText === "function") {
      navigator.clipboard.writeText(text).catch(() => legacyCopy(text));
    } else {
      legacyCopy(text);
    }
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

  function enterHintMode(action) {
    if (hintMode) return;
    hintMode = true;
    hintAction = action || "click";
    typed = "";
    makeOverlay();

    const els = clickableElements(hintAction);
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
      if (hintAction === "copy") {
        const url = resolveLink(matches[0].el);
        if (url) copyText(url);
      } else {
        matches[0].el.click();
      }
      cleanupHints();
    }
  }

  let lastG = 0;
  let lastComma = 0;

  document.addEventListener("keydown", (e) => {
    if (e.key === "Escape" && isTypingTarget(document.activeElement)) {
      e.preventDefault();
      if (typeof document.activeElement.blur === "function") {
        document.activeElement.blur();
      }
      return;
    }

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

    // ,m => hint-copy mode
    if (e.key === ",") {
      e.preventDefault();
      lastComma = Date.now();
      return;
    }
    if (lastComma && Date.now() - lastComma >= 400) {
      lastComma = 0;
    }
    if ((e.key === "m" || e.key === "M") && lastComma) {
      e.preventDefault();
      lastComma = 0;
      enterHintMode("copy");
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
      case "f": e.preventDefault(); enterHintMode("click"); break;
    }
  }, true);
})();
