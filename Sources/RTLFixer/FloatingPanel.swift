import AppKit
import SwiftUI

/// Owns the floating non-activating NSPanel that displays the RTL text.
final class FloatingPanelController {

    private var panel: NSPanel?
    private var escapeMonitor: Any?
    private var outsideClickMonitor: Any?
    private var currentText = ""
    private(set) var isExpanded = false

    // MARK: - Public

    func show(text: String) {
        let panel = ensurePanel()
        currentText = text
        updateContent(of: panel, text: text)
        if isExpanded {
            applyExpandedFrame(to: panel, animate: false)
        } else {
            position(panel: panel, near: NSEvent.mouseLocation)
        }

        panel.alphaValue = 0
        panel.orderFrontRegardless()
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.15
            panel.animator().alphaValue = 1
        }
        installMonitors()
    }

    func hide() {
        removeMonitors()
        guard let panel else { return }
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.12
            panel.animator().alphaValue = 0
        }, completionHandler: {
            panel.orderOut(nil)
        })
    }

    /// Toggles between the compact bubble and a near-fullscreen layout.
    func toggleExpand() {
        isExpanded.toggle()
        guard let panel, panel.isVisible else { return }
        updateContent(of: panel, text: currentText)
        if isExpanded {
            applyExpandedFrame(to: panel, animate: true)
        } else {
            NSAnimationContext.runAnimationGroup({ context in
                context.duration = 0.2
                context.allowsImplicitAnimation = true
                self.position(panel: panel, near: NSEvent.mouseLocation)
                panel.display()
            })
        }
    }

    var isVisible: Bool { panel?.isVisible ?? false }

    // MARK: - Panel

    private func ensurePanel() -> NSPanel {
        if let panel { return panel }

        let panel = NSPanel(
            contentRect: NSRect(x: 0, y: 0, width: 440, height: 240),
            styleMask: [.borderless, .nonactivatingPanel, .resizable],
            backing: .buffered,
            defer: false)

        panel.isOpaque = false
        panel.backgroundColor = .clear
        panel.hasShadow = true
        panel.level = .floating
        panel.isMovableByWindowBackground = true
        panel.hidesOnDeactivate = false
        // .fullScreenAuxiliary makes the panel appear above fullscreen apps too.
        panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary, .stationary, .ignoresCycle]
        panel.becomesKeyOnlyIfNeeded = true
        panel.minSize = NSSize(width: 320, height: 160)
        self.panel = panel
        return panel
    }

    private func updateContent(of panel: NSPanel, text: String) {
        let view = FloatingContentView(
            text: text,
            isExpanded: isExpanded,
            onClose: { [weak self] in self?.hide() },
            onCopy: {
                let pasteboard = NSPasteboard.general
                pasteboard.clearContents()
                pasteboard.setString(text, forType: .string)
            },
            onToggleExpand: { [weak self] in self?.toggleExpand() })
        panel.contentView = NSHostingView(rootView: view)
    }

    private func applyExpandedFrame(to panel: NSPanel, animate: Bool) {
        let screen = panel.screen ?? NSScreen.main
        let frame = (screen?.visibleFrame ?? NSRect(x: 0, y: 0, width: 1440, height: 900))
            .insetBy(dx: 48, dy: 48)
        panel.setFrame(frame, display: true, animate: animate)
    }

    private func position(panel: NSPanel, near mouse: NSPoint) {
        let screen = NSScreen.screens.first { NSMouseInRect(mouse, $0.frame, false) } ?? NSScreen.main
        let frame = screen?.visibleFrame ?? NSRect(x: 0, y: 0, width: 1440, height: 900)

        let size = idealSize(for: (panel.contentView as? NSHostingView<FloatingContentView>)?.rootView.text ?? "")
        var origin = NSPoint(x: mouse.x - size.width / 2, y: mouse.y + 28)
        origin.x = min(max(origin.x, frame.minX + 12), frame.maxX - size.width - 12)
        origin.y = min(max(origin.y, frame.minY + 12), frame.maxY - size.height - 12)

        panel.setFrame(NSRect(origin: origin, size: size), display: true)
    }

    private func idealSize(for text: String) -> NSSize {
        let width: CGFloat = 440
        // Rough wrap estimate: ~30 characters per line at 17pt, 26pt per line.
        let lines = max(1, Int((Double(text.count) / 30.0).rounded(.up)))
        let height = min(520, max(190, CGFloat(lines) * 26 + 110))
        return NSSize(width: width, height: height)
    }

    // MARK: - Monitors (Escape / outside click)

    private func installMonitors() {
        removeMonitors()

        escapeMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] event in
            if event.keyCode == 53 /* Escape */ {
                self?.hide()
                return nil
            }
            return event
        }

        // Global monitor fires only for clicks outside our own process,
        // so clicks inside the panel don't dismiss it.
        outsideClickMonitor = NSEvent.addGlobalMonitorForEvents(
            matching: [.leftMouseDown, .rightMouseDown, .otherMouseDown]) { [weak self] _ in
            self?.hide()
        }
    }

    private func removeMonitors() {
        if let escapeMonitor {
            NSEvent.removeMonitor(escapeMonitor)
            self.escapeMonitor = nil
        }
        if let outsideClickMonitor {
            NSEvent.removeMonitor(outsideClickMonitor)
            self.outsideClickMonitor = nil
        }
    }
}
