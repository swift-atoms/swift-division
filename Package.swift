// swift-tools-version: 6.4
import PackageDescription

let package = Package(
    name: "swift-division",
    platforms: [.macOS(.v27), .iOS(.v27), .tvOS(.v27), .watchOS(.v27), .visionOS(.v27)],
    products: [
        .library(name: "Division", targets: ["Division"]),
        .library(name: "Division Standard Library Integration", targets: ["Division Standard Library Integration"]),
        .library(name: "Division Foundation Library Integration", targets: ["Division Foundation Library Integration"]),
        .library(name: "Division Test Support", targets: ["Division Test Support"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-atoms/swift-addition.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-subtraction.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-polarity.git", branch: "main"),
    ],
    targets: [
        .target(
            name: "Division",
            dependencies: [
                .product(name: "Addition", package: "swift-addition"),
                .product(name: "Subtraction", package: "swift-subtraction"),
                .product(name: "Polarity", package: "swift-polarity"),
            ],
            path: "Sources/Division"
        ),
        .target(
            name: "Division Standard Library Integration",
            dependencies: [
                .target(name: "Division"),
            ],
            path: "Sources/Division Standard Library Integration"
        ),
        .target(
            name: "Division Foundation Library Integration",
            dependencies: [
                .target(name: "Division"),
                .target(name: "Division Standard Library Integration"),
            ],
            path: "Sources/Division Foundation Library Integration"
        ),
        .target(
            name: "Division Test Support",
            dependencies: [
                .target(name: "Division"),
            ],
            path: "Tests/Support"
        ),
        .testTarget(
            name: "Division Tests",
            dependencies: [
                .target(name: "Division"),
                .product(name: "Addition", package: "swift-addition"),
                .product(name: "Subtraction", package: "swift-subtraction"),
                .product(name: "Polarity", package: "swift-polarity"),
                .target(name: "Division Test Support"),
                .target(name: "Division Standard Library Integration"),
                .target(name: "Division Foundation Library Integration"),
            ],
            path: "Tests/Division Tests"
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets {
    target.swiftSettings = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]
}
