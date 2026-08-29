import SwiftUI

/// Font used across the app — Vazirmatn (bundled in Resources/fonts).
enum AppFont {
    static func vazir(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        let name: String
        switch weight {
        case .semibold, .bold: name = "Vazirmatn-Bold"
        case .medium:          name = "Vazirmatn-Medium"
        default:               name = "Vazirmatn"
        }
        return .custom(name, size: size)
    }
}

/// The floating panel's content: RTL text inside a Liquid Glass capsule.
struct FloatingContentView: View {

    let text: String
    var isExpanded: Bool
    var fontSize: CGFloat
    var onClose: () -> Void
    var onCopy: () -> Void
    var onToggleExpand: () -> Void
    var onChangeFont: (CGFloat) -> Void

    @State private var copied = false

    var body: some View {
        VStack(spacing: 0) {
            header
            Divider().opacity(0.15)
            ScrollView {
                Text(text)
                    .textSelection(.enabled)
                    .multilineTextAlignment(.trailing)
                    .font(AppFont.vazir(fontSize))
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(16)
            }
        }
        .environment(\.layoutDirection, .rightToLeft)
        .glassEffect(.regular, in: .rect(cornerRadius: isExpanded ? 30 : 26))
    }

    private var header: some View {
        HStack(spacing: 8) {
            Image(systemName: "text.alignright")
                .foregroundStyle(.secondary)
            Text("RTL Fixer")
                .font(AppFont.vazir(12, weight: .semibold))
                .foregroundStyle(.secondary)
            Spacer()

            Button {
                onChangeFont(-2)
            } label: {
                Image(systemName: "minus.circle")
            }
            .buttonStyle(.borderless)
            .keyboardShortcut("-", modifiers: .command)
            .help("فونت کوچک‌تر (⌘−)")

            Button {
                onChangeFont(+2)
            } label: {
                Image(systemName: "plus.circle")
            }
            .buttonStyle(.borderless)
            .keyboardShortcut("+", modifiers: .command)
            .help("فونت بزرگ‌تر (⌘+)")

            Button {
                onChangeFont(0)
            } label: {
                Image(systemName: "arrow.counterclockwise.circle")
            }
            .buttonStyle(.borderless)
            .keyboardShortcut("0", modifiers: .command)
            .help("اندازه‌ی پیش‌فرض (⌘0)")

            Button {
                onToggleExpand()
            } label: {
                Image(systemName: isExpanded
                      ? "arrow.down.right.and.arrow.up.left"
                      : "arrow.up.left.and.arrow.down.right")
            }
            .buttonStyle(.borderless)
            .help(isExpanded ? "حالت کوچک" : "حالت بزرگ (تقریباً تمام‌صفحه)")

            Button {
                onCopy()
                copied = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { copied = false }
            } label: {
                Label(copied ? "کپی شد" : "کپی", systemImage: copied ? "checkmark" : "doc.on.doc")
                    .labelStyle(.iconOnly)
            }
            .buttonStyle(.borderless)
            .help("کپی متن")

            Button {
                onClose()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .foregroundStyle(.secondary)
            }
            .buttonStyle(.borderless)
            .keyboardShortcut(.cancelAction)
            .help("بستن (Esc)")
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }
}
