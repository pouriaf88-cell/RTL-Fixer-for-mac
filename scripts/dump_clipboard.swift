// Dumps the image currently on the clipboard to assets/logo-source.png (if any).
import AppKit

let pasteboard = NSPasteboard.general
guard let image = NSImage(pasteboard: pasteboard) else {
    print("NOT_ON_CLIPBOARD")
    exit(0)
}
let tiff = image.tiffRepresentation!
let rep = NSBitmapImageRep(data: tiff)!
let png = rep.representation(using: .png, properties: [:])!
try! png.write(to: URL(fileURLWithPath: "assets/logo-source.png"))
print("FOUND_ON_CLIPBOARD \(rep.pixelsWide)x\(rep.pixelsHigh)")
