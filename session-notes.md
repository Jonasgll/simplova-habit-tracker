# Claude Code Session — Habit Tracker
**Datum:** 17. April 2026  
**Projekt:** Simplova Habit Tracker  
**Repo:** https://github.com/Jonasgll/simplova-habit-tracker  
**Live:** https://jonasgll.github.io/simplova-habit-tracker/

---

## 🐛 Bug Fix: Mobile Scroll (PR #1 — gemerged)

### Problem
Im zweiten Onboarding-Schritt (Habit-Auswahl) konnte man auf dem Handy (Chrome & Safari) nicht scrollen. Der „Los geht's"-Button war nicht erreichbar.

### Ursache
Zwei Stellen waren fehlerhaft:

1. **CSS** `index.html:575` — `.onboarding` hatte `display: grid; place-items: center` ohne `overflow-y: auto`
2. **JS** `index.html:1884` — `startOnboardingIfNeeded()` setzte `style.display = 'grid'` als Inline-Stil und überschrieb damit den CSS-Fix

### Fix
```css
/* vorher */
.onboarding {
  display: grid;
  place-items: center;
}

/* nachher */
.onboarding {
  display: flex;
  flex-direction: column;
  align-items: center;
  overflow-y: auto;
  -webkit-overflow-scrolling: touch;
}
.onboarding-inner { margin: auto; }
```

```js
// vorher
document.getElementById('onboarding').style.display = 'grid';

// nachher
document.getElementById('onboarding').style.display = 'flex';
```

---

## ✅ PWA & Performance Fixes (PR #2 — gemerged)

| Fix | Datei | Details |
|-----|-------|---------|
| `<link rel="manifest">` fehlte | `index.html` | Browser erkannte App nicht als PWA |
| Apple Touch Icon fehlte | `index.html` | Kein Icon beim Hinzufügen zum Homescreen |
| Inline Service Worker | `index.html:2032` | Leerer Fetch-Handler deaktivierte Offline-Caching aus `sw.js` |
| Chart.js blockierte Render | `index.html:14` | `defer` hinzugefügt |
| `background_color` falsch | `manifest.json` | `#1A1A2E` → `#fafbfc` (Hell-Modus) |
| Icons fehlten | `icon-192.png`, `icon-512.png` | Mit Simplova-Branding erstellt (weißer BG, teal „S") |

---

## 📄 Kunden-Anleitung

Datei: `guide.html`  
URL: https://jonasgll.github.io/simplova-habit-tracker/guide.html

Zweiseitiges druckbares Dokument (identisches Design wie Budget Tracker):
- **Seite 1:** Persönlicher Link, 4 Schritte, iPhone Tip
- **Seite 2:** „What's included" mit 8 Features

---

## 🖼️ Etsy Mockups (7 Stück)

Pfad: `mockups/` — 1200×1200px PNG

| Datei | Titel | Eugene Schwartz Level |
|-------|-------|----------------------|
| `01_hero.png` | Daily Habit Tracker — Phone Mockup | Produkt-bewusst |
| `02_problem.png` | "You start. You forget. You give up." | Problem-bewusst |
| `03_streak.png` | 21 Day Streak | Lösungs-bewusst (Desire) |
| `04_features.png` | Everything included — Feature Grid | Produkt-bewusst |
| `05_howto.png` | 3 steps. Better habits. | Lösungs-bewusst |
| `06_lifestyle.png` | Make habits feel good. | Vollständig bewusst (Desire) |
| `07_download.png` | Instant Download — Value + CTA | Vollständig bewusst (Conversion) |

---

## 🔍 Code Review Findings (offen)

### Accessibility (nicht behoben)
- FAB-Button (`+`) fehlt `aria-label`
- Modal fehlt `role="dialog" aria-modal="true"`
- Habit-Rows als `<div>` statt `<button>`

### Kleinigkeiten (nicht behoben)
- Keine Keyboard-Navigation
- Kein Focus-Trap im Modal

---

## 📁 Dateien im Repo

```
simplova-habit-tracker/
├── index.html          # Haupt-App (alle Fixes drin)
├── manifest.json       # PWA Manifest (gefixt)
├── sw.js               # Service Worker (jetzt aktiv)
├── icon-192.png        # PWA Icon (neu)
├── icon-512.png        # PWA Icon (neu)
├── guide.html          # Kunden-Anleitung (neu)
└── mockups/
    ├── 01_hero.png
    ├── 02_problem.png
    ├── 03_streak.png
    ├── 04_features.png
    ├── 05_howto.png
    ├── 06_lifestyle.png
    └── 07_download.png
```

---

*Erstellt mit Claude Code — SimplovaStudio*
