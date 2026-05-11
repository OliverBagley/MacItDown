// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "MarkItDownApp",
    platforms: [
        .macOS(.v15)
    ],
    products: [
        .executable(
            name: "MarkItDownApp",
            targets: ["MarkItDownApp"]
        )
    ],
    targets: [
        .executableTarget(
            name: "MarkItDownApp",
            path: "Sources/MarkItDownApp",
            resources: [
                .process("../../Resources")
            ],
            swiftSettings: [
                .swiftLanguageMode(.v5)
            ]
        )
    ]
)
