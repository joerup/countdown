// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CountdownUI",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .watchOS(.v10),
        .tvOS(.v17)
    ],
    products: [
        .library(
            name: "CountdownUI",
            targets: ["CountdownUI"]
        ),
    ],
    dependencies: [
        .package(path: "../CountdownData"),
    ],
    targets: [
        .target(
            name: "CountdownUI",
            dependencies: [
                .product(name: "CountdownData", package: "CountdownData", condition: nil)
            ],
            path: "."
        ),
    ]
)
