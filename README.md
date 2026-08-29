<div align="center">

# 🪟 RTL Fixer

**Select any text, hit ⌥R — a floating Liquid Glass panel shows the same text with proper right-to-left alignment.**

For every place where Persian/Arabic and English get mixed up and the text alignment drives you crazy.

[![macOS](https://img.shields.io/badge/macOS-26%2B-black?logo=apple&logoColor=white)](https://www.apple.com/macos/)
[![Swift](https://img.shields.io/badge/Swift-6-orange?logo=swift&logoColor=white)](https://www.swift.org)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Liquid Glass](https://img.shields.io/badge/UI-Liquid%20Glass-8e7cf5)](README.fa.md)

**English** | [فارسی](README.fa.md)

</div>

---

## ✨ Features

- 🖥️ **Floating Liquid Glass panel** (the real macOS 26 `glassEffect` API)
- ⌨️ Global hotkey **⌥R** — works from anywhere
- 🖱️ **Dock icon** — clicking it does the same as the hotkey (open/close)
- 📖 Reads the selected text via the Accessibility API — **never touches your clipboard**
- 📋 Automatic ⌘C fallback for apps that don't report selected text (e.g. browsers)
- 🔍 **Expanded mode** — one click makes the panel near-fullscreen; great for long texts
- 🖥️ The panel shows **above fullscreen apps** too
- 📝 Text is selectable and copyable inside the panel; close with `Esc` or an outside click
- 🔤 Rendered in **Vazirmatn** — the beautiful open-source Persian font (bundled, zero setup)
- **Adjustable font size** — A+ / A− buttons in the panel header, or `⌘+` / `⌘−` (`⌘0` resets). Your choice is remembered.

## 📦 Download a ready-made build

Grab **`RTL-Fixer-1.1.0.zip`** from the [Releases](../../releases) page, unzip, and move the app to `/Applications`.

Since the app isn't notarized, macOS may block it the first time. Either:

- run `xattr -cr "RTL Fixer.app"` in Terminal, **or**
- right-click the app → **Open** (twice) in the warning dialog.

## 🚀 Install

### Requirements

- macOS 26 (Tahoe) or newer
- Xcode or just the Command Line Tools to build:
  ```bash
  xcode-select --install
  ```

### Build & run

```bash
git clone https://github.com/<username>/rtl-fixer.git
cd rtl-fixer
./build.sh
open "build/RTL Fixer.app"
```

Or move it into `/Applications` so the Dock icon stays stable:

```bash
cp -R "build/RTL Fixer.app" /Applications/
open -a "RTL Fixer"
```

### Accessibility permission (first launch only)

macOS will prompt you the first time:

> **System Settings ← Privacy & Security ← Accessibility ← enable "RTL Fixer"**

### Pin it to the Dock

1. Launch the app
2. Right-click its Dock icon ← **Options ← Keep in Dock**

## 🕹️ Usage

1. Select any text (a website, Telegram, a PDF — anywhere!)
2. Press **⌥R** (or click the Dock icon)
3. A glass panel opens near your cursor showing the text **properly right-to-left**
4. The 🔍 button expands the panel, 📋 copies the text
5. Close with `Esc` or by clicking outside the panel

## 🛠️ Troubleshooting

**The Accessibility toggle is on but the app still asks for permission?**
This used to happen after rebuilds because the ad-hoc signature changed. It's fixed now — the app is signed with a stable self-signed certificate (`RTL Fixer Developer`), so the grant survives rebuilds. If it ever happens again:

```bash
./fix-permission.sh
```

**Building from source yourself?** The build signs ad-hoc if the stable identity isn't in your keychain. Every rebuild with ad-hoc signing invalidates the Accessibility grant (macOS limitation). Sign with your own stable certificate to avoid it.

## 📦 Publishing a release

Maintainers can produce a distributable zip:

```bash
./make-release.sh
```

This creates `release/RTL-Fixer-<version>.zip` (+ SHA256) ready to upload to GitHub Releases.

## 🧱 How it works

| Component | What it does |
|---|---|
| `SelectionReader` | Reads `kAXSelectedTextAttribute` from the focused app; falls back to simulated ⌘C |
| `HotKeyManager` | Global hotkey via Carbon `RegisterEventHotKey` |
| `FloatingPanel` | Borderless, non-activating `NSPanel` with `.fullScreenAuxiliary` |
| `FloatingContentView` | SwiftUI with `layoutDirection(.rightToLeft)` and `glassEffect` |

## 📄 License

MIT — use it, change it, ship it. See [LICENSE](LICENSE).

The bundled [Vazirmatn](https://github.com/rastikerdar/vazirmatn) font is © The Vazirmatn Project Authors, released under the [SIL Open Font License 1.1](https://openfontlicense.org).
