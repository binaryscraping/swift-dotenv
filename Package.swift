// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "swift-dotenv",
  platforms: [.macOS(.v10_15)],
  products: [
    .library(name: "DotEnvCore", targets: ["DotEnvCore"]),
    .executable(name: "swift-dotenv", targets: ["swift-dotenv"]),
    .plugin(name: "DotEnvPlugin", targets: ["DotEnvPlugin"]),
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-argument-parser", from: "1.1.3")
  ],
  targets: [
    .target(name: "DotEnvCore"),
    .testTarget(
      name: "DotEnvCoreTests",
      dependencies: [
        "DotEnvCore"
      ]
    ),
    .executableTarget(
      name: "swift-dotenv",
      dependencies: [
        "DotEnvCore",
        .product(name: "ArgumentParser", package: "swift-argument-parser"),
      ]
    ),
    .plugin(name: "DotEnvPlugin", capability: .buildTool()),
  ]
)
