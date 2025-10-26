// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "Flags",
    platforms: [
        .macOS(.v11)
    ],
    dependencies: [
        .package(path: "../../")
    ],
    targets: [
        .executableTarget(
            name: "Flags",
            dependencies: ["SwiftTUI"]),
        .testTarget(
            name: "FlagsTests",
            dependencies: ["Flags"]),
    ]
)
