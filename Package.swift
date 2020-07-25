// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Compote",
    platforms: [
        .macOS("10.15")
    ],
    products: [
        .library(name: "Compote", targets: ["Compote"]),
        .executable(name: "Notes", targets: ["Notes"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.0.0"),
        .package(url: "https://github.com/apple/swift-log.git", Version("0.0.0")..<Version("2.0.0")),
        .package(url: "https://github.com/swift-server/async-http-client.git", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "0.2.0"),
    ],
    targets: [
        .target(name: "Compote", dependencies: [
            .product(name: "NIO", package: "swift-nio"),
            .product(name: "Logging", package: "swift-log"),
            .product(name: "AsyncHTTPClient", package: "async-http-client"),
            .product(name: "ArgumentParser", package: "swift-argument-parser"),
        ]),
        .testTarget(name: "CompoteTests", dependencies: ["Compote"]),
        .target(name: "Notes", dependencies: ["Compote"]),
    ]
)
