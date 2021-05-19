// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SolarNOAA",
    platforms: [
        .macOS(.v10_10),
        .iOS(.v9),
        .tvOS(.v9),
        .watchOS(.v2)
    ],
    products: [
        .library(
            name: "SolarNOAA",
            targets: ["SolarNOAA"]
        ),
    ],
    targets: [
        .target(
            name: "SolarNOAA",
            path: "Sources"
        ),
        .testTarget(
            name: "SolarNOAATests",
            dependencies: ["SolarNOAA"],
            path: "Tests"
        ),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
