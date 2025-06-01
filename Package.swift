// swift-tools-version:6.0

import PackageDescription

let package = Package(
    name: "XcodeProjKit",
    products: [
        .library(
            name: "XcodeProjKit",
            targets: ["XcodeProjKit"]
        )
    ],
    targets: [
        .target(name: "XcodeProjKit", path: "Sources"),
        .testTarget(name: "Tests", dependencies: ["XcodeProjKit"], path: "Tests")
    ]
)
