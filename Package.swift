// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Networker",
    platforms: [
        .iOS(.v14),
    ],
    products: [
        .library(
            name: "Networker",
            targets: ["Networker"]),
    ],
    targets: [
        .target(
            name: "Networker"),
    ]
)
