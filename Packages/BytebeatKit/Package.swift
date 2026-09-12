// swift-tools-version: 6.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "BytebeatKit",
  platforms: [
    .macOS(.v26),
    .macCatalyst(.v26),
    .iOS(.v26),
    .tvOS(.v26),
    .watchOS(.v26),
    .visionOS(.v26),
  ],
  products: [
    .library(
      name: "BytebeatKit",
      targets: ["BytebeatKit"]
    ),
    .library(
      name: "BytebeatPlayground",
      targets: ["BytebeatPlayground"]
    ),
  ],
  targets: [
    .target(
      name: "BytebeatKit"
    ),
    .target(
      name: "BytebeatPlayground",
      dependencies: ["BytebeatKit"]
    ),
    .testTarget(
      name: "BytebeatKitTests",
      dependencies: ["BytebeatKit"]
    ),
  ]
)
