import SwiftUI

/// The floating panel's content: RTL text inside a Liquid Glass capsule.
struct FloatingContentView: View {

    let text: String
    var isExpanded: Bool
    var onClose: () -> Void
    var onCopy: () -> Void
    var onToggleExpand: () -> Void

    @State private var copied = false

    var body: some View {
        VStack(spacing: 0) {
            header
            Divider().opacity(0.15)
            ScrollView {
                Text(text)
                    .textSelection(.enabled)
                    .multilineTextAlignment(.trailing)
                    .font(.system(size: isExpanded ? 21 : 17))
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
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(.secondary)
            Spacer()
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
