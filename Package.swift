// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "SwiftTUI",
    platforms: [
        .macOS(.v11)
    ],
    products: [
        .library(
            name: "SwiftTUI",
            targets: ["SwiftTUI"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "SwiftTUI",
            dependencies: []),
        .testTarget(
            name: "SwiftTUITests",
            dependencies: ["SwiftTUI"]),
    ]
)
