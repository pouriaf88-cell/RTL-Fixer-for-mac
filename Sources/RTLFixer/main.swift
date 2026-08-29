import AppKit
import CoreText

// MARK: - Font Registration

/// Registers the bundled Vazirmatn fonts (Resources/fonts) with CoreText so
/// SwiftUI's `.custom("Vazirmatn…")` resolves to them.
func registerBundledFonts() {
    let fontNames = ["Vazirmatn", "Vazirmatn-Medium", "Vazirmatn-Bold"]
    for name in fontNames {
        guard let url = Bundle.main.url(forResource: name, withExtension: "ttf", subdirectory: "fonts")
                ?? Bundle.main.url(forResource: name, withExtension: "ttf") else { continue }
        CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
    }
}

// MARK: - App Delegate

final class AppDelegate: NSObject, NSApplicationDelegate {

    private var statusItem: NSStatusItem!
    private let hotKeyManager = HotKeyManager()
    private let panelController = FloatingPanelController()
    private var permissionRequested = false

    func applicationDidFinishLaunching(_ notification: Notification) {
        // .regular so the app gets a Dock icon (pin it via Right-click → Options → Keep in Dock).
        NSApp.setActivationPolicy(.regular)
        registerBundledFonts()
        setupStatusItem()

        hotKeyManager.onToggle = { [weak self] in self?.togglePanel() }
        hotKeyManager.register()

        // Ask for Accessibility permission on first launch (needed to read
        // the selected text and to simulate ⌘C in other apps).
        if !SelectionReader.ensureAccessibilityPermission(prompt: !permissionRequested) {
            permissionRequested = true
        }
    }

    func applicationWillTerminate(_ notification: Notification) {
        panelController.hide()
    }

    /// Clicking the Dock icon (while the app is already running) toggles the panel —
    /// same as pressing ⌥R: opens it if closed, closes it if open.
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        togglePanel()
        return true
    }

    // MARK: - Actions

    private func togglePanel() {
        if panelController.isVisible {
            panelController.hide()
            return
        }

        if !SelectionReader.ensureAccessibilityPermission(prompt: true) {
            showPanelWithMessage(
                "دسترسی Accessibility داده نشده!\n\n"
                + "تنظیمات ← حریم خصوصی و امنیت ← دسترسی‌پذیری\n"
                + "برای «RTL Fixer» دسترسی فعال کن.")
            return
        }

        if let text = SelectionReader.readSelectedText() {
            showPanelWithMessage(text)
        } else {
            showPanelWithMessage(
                "متنی انتخاب نشده بود.\n\n"
                + "اول یه متن انتخاب کن، بعد ⌥R بزن.")
        }
    }

    private func showPanelWithMessage(_ text: String) {
        panelController.show(text: text)
    }

    // MARK: - Status Item

    private func setupStatusItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem.button?.title = "‬RTL‪"
        statusItem.button?.font = NSFont(name: "Vazirmatn-Bold", size: 12)
            ?? NSFont.systemFont(ofSize: 12, weight: .semibold)

        let menu = NSMenu()
        let hotkeyItem = NSMenuItem(title: "میانبر: ⌥R", action: nil, keyEquivalent: "")
        hotkeyItem.isEnabled = false
        menu.addItem(hotkeyItem)
        menu.addItem(.separator())

        let toggleItem = NSMenuItem(title: "نمایش / پنهان", action: #selector(toggleFromMenu), keyEquivalent: "r")
        toggleItem.keyEquivalentModifierMask = [.option]
        toggleItem.target = self
        menu.addItem(toggleItem)

        let permissionItem = NSMenuItem(title: "بررسی دسترسی Accessibility", action: #selector(checkPermission), keyEquivalent: "")
        permissionItem.target = self
        menu.addItem(permissionItem)

        menu.addItem(.separator())
        let quitItem = NSMenuItem(title: "خروج", action: #selector(quit), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)

        statusItem.menu = menu
    }

    @objc private func toggleFromMenu() {
        togglePanel()
    }

    @objc private func checkPermission() {
        if SelectionReader.ensureAccessibilityPermission(prompt: true) {
            showPanelWithMessage("دسترسی Accessibility فعاله. ✅")
        }
    }

    @objc private func quit() {
        NSApp.terminate(nil)
    }
}

// MARK: - Entry Point

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.run()
