// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "Stardust",
    products: [
        .library(name: "Stardust", type: .dynamic, targets: ["Stardust"]),
        .executable(name: "stardust-cli", targets: ["Runner"])

    ],
    dependencies: [
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        .target(name: "Stardust", dependencies: []),
        .testTarget(name: "StardustTests", dependencies: ["Stardust"]),
        .target(name: "Runner", dependencies: ["Stardust"]),
    ]
)
