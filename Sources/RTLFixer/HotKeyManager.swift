import Carbon.HIToolbox

/// Registers a global hotkey (⌥R) using the Carbon Event Manager.
/// No third-party dependency needed.
final class HotKeyManager {

    var onToggle: (() -> Void)?

    private var hotKeyRef: EventHotKeyRef?
    private var eventHandler: EventHandlerRef?

    func register(keyCode: UInt32 = UInt32(kVK_ANSI_R), modifiers: UInt32 = UInt32(optionKey)) {
        var eventType = EventTypeSpec(
            eventClass: OSType(kEventClassKeyboard),
            eventKind: UInt32(kEventHotKeyPressed))

        let callback: EventHandlerUPP = { _, _, userData in
            guard let userData else { return noErr }
            let manager = Unmanaged<HotKeyManager>.fromOpaque(userData).takeUnretainedValue()
            DispatchQueue.main.async { manager.onToggle?() }
            return noErr
        }

        let status = InstallEventHandler(
            GetApplicationEventTarget(),
            callback,
            1,
            &eventType,
            Unmanaged.passUnretained(self).toOpaque(),
            &eventHandler)
        guard status == noErr else {
            NSLog("RTL Fixer: InstallEventHandler failed: \(status)")
            return
        }

        let hotKeyID = EventHotKeyID(signature: OSType(0x5254_4C46) /* 'RTLF' */, id: 1)
        let registerStatus = RegisterEventHotKey(
            keyCode, modifiers, hotKeyID, GetApplicationEventTarget(), 0, &hotKeyRef)
        if registerStatus != noErr {
            NSLog("RTL Fixer: RegisterEventHotKey failed: \(registerStatus)")
        }
    }
}
