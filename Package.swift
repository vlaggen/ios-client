// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ios-client",
    platforms: [
        .iOS(.v10),
    ],
    products: [
        .library(name: "Vlaggen", targets: ["Vlaggen"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vlaggen/swift-networking.git", from: "1.0.1"),
    ],
    targets: [
        .target(name: "Vlaggen", dependencies: [
            .product(name: "VlaggenNetworking", package: "swift-networking"),
        ], path: "./Sources"),

        .testTarget(name: "VlaggenTests", dependencies: [
            .target(name: "Vlaggen"),
        ]),
    ]
)
