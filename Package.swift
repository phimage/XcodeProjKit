// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "XcodeProjKit",
    targets: [
        .target(name: "XcodeProjKit", path: "Sources"),
        .testTarget(name: "Tests", dependencies: ["XcodeProjKit"], path: "Tests")
    ]
)
