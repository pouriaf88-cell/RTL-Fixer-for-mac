// swift-tools-version:6.2
import PackageDescription

let package = Package(
    name: "RTLFixer",
    platforms: [.macOS(.v26)],
    targets: [
        .executableTarget(
            name: "RTLFixer",
            path: "Sources/RTLFixer"
        )
    ],
    swiftLanguageModes: [.v5]
)
