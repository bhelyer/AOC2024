// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "advent",
    platforms: [
        .macOS(.v15)
    ],
    products: [
        .executable(name: "Advent", targets: ["Advent"])
    ],
    targets: [
        .executableTarget(name: "Advent", dependencies: [])
    ]
)
