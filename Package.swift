// swift-tools-version: 6.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TrustlessSDK",
    platforms: [
        .iOS(.v15),
    ],
    products: [
        .library(
            name: "TrustlessSDK",
            targets: ["TrustlessSDKTarget"]),
    ],
    targets: [
        .binaryTarget(
            name: "TrustlessSDK",
            path: "./Sources/TrustlessSDK.xcframework"
        ),
        .target(
            name: "TrustlessSDKTarget",
            dependencies: [
                .target(name: "TrustlessSDK")
            ],
            path: "Sources/TrustlessSDKTarget",
            sources: ["TrustlessSDKEmpty.m"],
            publicHeadersPath: "Sources"
        )
    ]
)
