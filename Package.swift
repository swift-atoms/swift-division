// swift-tools-version: 6.4
import PackageDescription

let package = Package(
    name: "swift-division",
    platforms: [.macOS(.v27), .iOS(.v27), .tvOS(.v27), .watchOS(.v27), .visionOS(.v27)],
    products: [.library(name: "Division", targets: ["Division"])],
    dependencies: [
        .package(url: "https://github.com/swift-atoms/swift-addition.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-subtraction.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-polarity.git", branch: "main"),
    ],
    targets: [
        .target(name: "Division", dependencies: [
            .product(name: "Addition", package: "swift-addition"),
            .product(name: "Subtraction", package: "swift-subtraction"),
            .product(name: "Polarity", package: "swift-polarity"),
        ]),
        .testTarget(name: "Division Tests", dependencies: [
            .target(name: "Division"),
            .product(name: "Addition", package: "swift-addition"),
            .product(name: "Subtraction", package: "swift-subtraction"),
            .product(name: "Polarity", package: "swift-polarity"),
        ]),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    target.swiftSettings = (target.swiftSettings ?? []) + [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]
}
