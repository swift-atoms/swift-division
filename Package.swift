// swift-tools-version: 6.4
import PackageDescription

let package = Package(
    name: "swift-division",
    platforms: [.macOS(.v27), .iOS(.v27), .tvOS(.v27), .watchOS(.v27), .visionOS(.v27)],
    products: [
        .library(name: "Division", targets: ["Division"]),

        .library(name: "Division Foundation Integration", targets: ["Division Foundation Integration"]),
        .library(name: "Division Test Support", targets: ["Division Test Support"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-atoms/swift-rounding.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-addition.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-subtraction.git", branch: "main"),
        .package(url: "https://github.com/swift-atoms/swift-polarity.git", branch: "main"),
    ],
    targets: [
        .target(
            name: "Division",
            dependencies: [
                .product(name: "Rounding", package: "swift-rounding"),
                .product(name: "Addition", package: "swift-addition"),
                .product(name: "Subtraction", package: "swift-subtraction"),
                .product(name: "Polarity", package: "swift-polarity"),
            ],
            path: "Sources/Division"
        ),
        
        .target(
            name: "Division Foundation Integration",
            dependencies: [
                .target(name: "Division"),
            ],
            path: "Sources/Division Foundation Integration"
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
                .target(name: "Division Foundation Integration"),
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
