// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "trustdart",
    platforms: [
        .iOS("13.0")
    ],
    products: [
        .library(name: "trustdart", targets: ["trustdart"])
    ],
    dependencies: [
        .package(name: "WalletCore", url: "https://github.com/trustwallet/wallet-core", from: "4.4.4")
    ],
    targets: [
        .target(
            name: "trustdart",
            dependencies: [
                .product(name: "WalletCore", package: "WalletCore"),
                .product(name: "WalletCoreSwiftProtobuf", package: "WalletCore")
            ]
        )
    ]
)
