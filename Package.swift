// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MagicExtensions",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "MagicExt-OAuth",
            targets: ["MagicExt-OAuth"]),
        .library(
            name: "MagicExt-OIDC",
            targets: ["MagicExt-OIDC"]),
    ],
    dependencies: [
        .package(url: "https://github.com/magiclabs/magic-ios.git", from: "10.1.1")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "MagicExt-OAuth",
            dependencies: [
                .product(name: "MagicSDK", package: "magic-ios"),
            ]),
        .target(
            name: "MagicExt-OIDC",
            dependencies: [
                .product(name: "MagicSDK", package: "magic-ios"),
            ]),
        .testTarget(
            name: "MagicExt-OAuthTests",
            dependencies: ["MagicExt-OAuth"]),
        .testTarget(
            name: "MagicExt-OIDCTests",
            dependencies: ["MagicExt-OIDC"]),
    ]
)
