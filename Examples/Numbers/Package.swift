// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "Numbers",
    platforms: [
        .macOS(.v12)
    ],
    dependencies: [
        .package(path: "../../")
    ],
    targets: [
        .executableTarget(
            name: "Numbers",
            dependencies: ["SwiftTUI"]),
        .testTarget(
            name: "NumbersTests",
            dependencies: ["Numbers"]),
    ]
)
