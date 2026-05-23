// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "MacItDown",
    platforms: [
        .macOS(.v15)
    ],
    products: [
        .executable(
            name: "MacItDown",
            targets: ["MacItDown"]
        )
    ],
    targets: [
        .executableTarget(
            name: "MacItDown",
            path: "Sources/MacItDown",
            resources: [
                .process("../../Resources")
            ],
            swiftSettings: [
                .swiftLanguageMode(.v5)
            ]
        )
    ]
)
