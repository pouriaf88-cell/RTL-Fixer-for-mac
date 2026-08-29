// Renders the RTL Fixer app icon (1024x1024 PNG) using CoreGraphics.
// Run from the repo root:  swift scripts/make_icon.swift
import AppKit

let size: CGFloat = 1024
let image = NSImage(size: NSSize(width: size, height: size))
image.lockFocus()

let rect = NSRect(x: 0, y: 0, width: size, height: size)

// macOS-style squircle background with a purple/indigo gradient
let path = NSBezierPath(roundedRect: rect, xRadius: 224, yRadius: 224)
path.addClip()

let gradient = NSGradient(
    starting: NSColor(red: 0.34, green: 0.31, blue: 0.96, alpha: 1),
    ending: NSColor(red: 0.62, green: 0.22, blue: 0.90, alpha: 1))!
gradient.draw(in: path, angle: -55)

// Soft highlight blob in the top-left for a glassy feel
let blob = NSBezierPath(ovalIn: NSRect(x: -180, y: 420, width: 900, height: 900))
NSColor(white: 1.0, alpha: 0.10).setFill()
blob.fill()

// Big "ع" — the RTL letter
let paragraph = NSMutableParagraphStyle()
paragraph.alignment = .center
let arabic = NSAttributedString(string: "ع", attributes: [
    .font: NSFont.systemFont(ofSize: 600, weight: .bold),
    .foregroundColor: NSColor.white,
    .paragraphStyle: paragraph,
])
let arabicSize = arabic.size()
arabic.draw(in: NSRect(x: 0, y: size - arabicSize.height - 170, width: size, height: arabicSize.height))

// "RTL" wordmark underneath
let latin = NSAttributedString(string: "RTL", attributes: [
    .font: NSFont.systemFont(ofSize: 150, weight: .heavy),
    .foregroundColor: NSColor(white: 1.0, alpha: 0.92),
    .paragraphStyle: paragraph,
    .kern: 6.0,
])
let latinSize = latin.size()
latin.draw(in: NSRect(x: 0, y: 150, width: size, height: latinSize.height))

image.unlockFocus()

let tiff = image.tiffRepresentation!
let rep = NSBitmapImageRep(data: tiff)!
let png = rep.representation(using: .png, properties: [:])!
try! png.write(to: URL(fileURLWithPath: "assets/icon-1024.png"))
print("✅ wrote assets/icon-1024.png")
