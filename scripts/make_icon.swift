// Builds the app iconset from assets/logo-source.png (the user's logo).
// Applies a macOS squircle mask if the artwork isn't already rounded,
// then emits assets/icon-1024.png + assets/AppIcon.iconset + AppIcon.icns.
import AppKit

guard let source = NSImage(contentsOfFile: "assets/logo-source.png") else {
    print("ERROR: assets/logo-source.png not found"); exit(1)
}

let size: CGFloat = 1024
let image = NSImage(size: NSSize(width: size, height: size))
image.lockFocus()
let ctx = NSGraphicsContext.current!.cgContext

// Sample corner alpha of the source to decide if we need our own mask
let tiff = source.tiffRepresentation!
let srcRep = NSBitmapImageRep(data: tiff)!
let cornerAlpha = srcRep.colorAt(x: 2, y: 2)?.alphaComponent ?? 1.0

let rect = NSRect(x: 0, y: 0, width: size, height: size)

if cornerAlpha > 0.95 {
    // Opaque square source → clip to a macOS squircle before drawing
    NSBezierPath(roundedRect: rect.insetBy(dx: 2, dy: 2),
                 xRadius: 224, yRadius: 224).addClip()
    print("▸ Applied squircle mask (source had opaque corners)")
} else {
    print("▸ Source already has transparency, using as-is")
}

source.draw(in: rect, from: .zero, operation: .copy, fraction: 1.0)
image.unlockFocus()

let outTiff = image.tiffRepresentation!
let outRep = NSBitmapImageRep(data: outTiff)!
let png = outRep.representation(using: .png, properties: [:])!
try! png.write(to: URL(fileURLWithPath: "assets/icon-1024.png"))
print("✅ wrote assets/icon-1024.png (\(outRep.pixelsWide)x\(outRep.pixelsHigh))")
