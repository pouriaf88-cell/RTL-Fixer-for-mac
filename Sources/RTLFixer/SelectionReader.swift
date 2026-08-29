import AppKit
import ApplicationServices

/// Reads the currently selected text from the frontmost application.
/// Strategy 1: Accessibility API (precise, no clipboard pollution).
/// Strategy 2: Simulate ⌘C and read the pasteboard (fallback for apps
///             that don't expose kAXSelectedTextAttribute, e.g. browsers).
enum SelectionReader {

    static func readSelectedText() -> String? {
        if let ax = axSelectedText() { return ax }
        return copyFallback()
    }

    /// Prompt macOS for Accessibility permission if not granted yet.
    @discardableResult
    static func ensureAccessibilityPermission(prompt: Bool) -> Bool {
        let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: prompt] as CFDictionary
        return AXIsProcessTrustedWithOptions(options)
    }

    // MARK: - Strategy 1: Accessibility API

    private static func axSelectedText() -> String? {
        let systemWide = AXUIElementCreateSystemWide()

        var focusedApp: CFTypeRef?
        let appResult = AXUIElementCopyAttributeValue(
            systemWide, kAXFocusedApplicationAttribute as CFString, &focusedApp)
        guard appResult == .success, let app = focusedApp else { return nil }

        let element = app as! AXUIElement
        var value: CFTypeRef?
        let result = AXUIElementCopyAttributeValue(
            element, kAXSelectedTextAttribute as CFString, &value)
        guard result == .success, let text = value as? String else { return nil }

        return text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : text
    }

    // MARK: - Strategy 2: Simulated ⌘C

    private static func copyFallback() -> String? {
        let pasteboard = NSPasteboard.general
        let changeCountBefore = pasteboard.changeCount

        guard let source = CGEventSource(stateID: .combinedSessionState) else { return nil }
        let keyDown = CGEvent(keyboardEventSource: source, virtualKey: 0x08 /* C */, keyDown: true)
        let keyUp = CGEvent(keyboardEventSource: source, virtualKey: 0x08, keyDown: false)
        keyDown?.flags = .maskCommand
        keyUp?.flags = .maskCommand
        keyDown?.post(tap: .cghidEventTap)
        keyUp?.post(tap: .cghidEventTap)

        // Wait (max ~1s) until the pasteboard actually changes.
        let deadline = Date().addingTimeInterval(1.0)
        while Date() < deadline {
            usleep(40_000)
            if pasteboard.changeCount != changeCountBefore {
                if let text = pasteboard.string(forType: .string),
                   !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    return text
                }
            }
        }
        return nil
    }
}
