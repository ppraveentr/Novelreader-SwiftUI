// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MobileContentManager",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "MobileContentManager", targets: ["ContentManager"])
    ],
    targets: [
        .target(name: "Networking"),
        .target(name: "ContentManager", dependencies: ["Networking"]),
        .testTarget(name: "ContentManagerTests", dependencies: ["ContentManager"])
    ]
)
