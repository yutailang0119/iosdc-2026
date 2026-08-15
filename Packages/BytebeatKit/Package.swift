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
    )
  ],
  targets: [
    .target(
      name: "BytebeatKit"
    ),
    .testTarget(
      name: "BytebeatKitTests",
      dependencies: ["BytebeatKit"]
    ),
  ]
)
